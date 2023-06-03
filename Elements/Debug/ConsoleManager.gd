extends Node

const SAVE_ROUTE = "res://_assets/Scripts/Custom Resources/PlayerSave.tres"
const DATA_ROUTE = "res://_assets/Scripts/Custom Resources/Data/CurrentData.tres"
var playerData : PlayerData = preload("res://_assets/Scripts/Custom Resources/PlayerSave.tres")
var dataDump : DataFile = preload("res://_assets/Scripts/Custom Resources/Data/CurrentData.tres")

var commandList : Dictionary = {
	"help": "help",
	"clear": "clear_log",
	"k_default": "knowledge_list_to_default",
	"console_color": "change_color",
	"reload_data": "reload_PlayerData",
	"reload": "reload_scene_cmmd", "reload_s": "reload_scene_cmmd",
	"name": "show_name", "myname": "show_name", "whoami": "show_name",
	"new_name": "change_name", "newname": "change_name", "nameTo": "change_name",
	"level": "show_level",
	"newlevel": "change_level"
}

@onready var argumentList : Dictionary = {
	'default': bgColors[0],
	'blue': bgColors[1],
	'pink': bgColors[2],
	'true': true, '-y': true, 'reload': true, '-r': true,
	'false': false, '-n': false,
	'remember': 'remember', "-re": 'remember'
}

@onready var inputLine : LineEdit = $consoleElements/writeLine
@onready var logScreen : RichTextLabel = $consoleElements/logPanel/consoleLog
@onready var logPanel : Panel = $consoleElements/logPanel
@export_category("Config")
@export_subgroup("Help lists")
@export var helpList : PackedStringArray # General
@export var helpChangeColor : PackedStringArray # change_color
@export var helpReloadData : PackedStringArray # reload_PlayerData
@export var helpReload : PackedStringArray # to any function that implements reload
@export_category("Colors")
@export_subgroup("Basics")
@export var normalColor : Color = Color.ANTIQUE_WHITE
@export var arrowColor : Color
@export var outputColor : Color
@export var doneColor : Color
@export var helpColor : Color
@export var errorColor : Color = Color.RED
@export var errorAltColor : Color
@export var bgColors : PackedColorArray

func _ready() -> void:
	inputLine.text_submitted.connect(get_text)
	Utilities.changeFlatboxColor_Panel(logPanel, dataDump.bgConsoleColor)
	
func get_text(textSubmitted : String):
	var textArray : PackedStringArray = textSubmitted.rsplit(" ")
	inputLine.clear()
	print_arrow()
	print_array(textArray, normalColor, false)
	check_command(textArray)

func check_command(textArray : PackedStringArray):
	if (textArray.size() <= 0): return
	var hasArguments : bool = false
	if (textArray.size() > 1): hasArguments = true
	
	var command : String = textArray[0].to_lower()
	
	var arguments : PackedStringArray
	
	if(hasArguments):
		for n in (textArray.size() - 1):
			arguments.append(textArray[n + 1])
	if (commandList.has(command)):
		var localFunction : String = commandList[command]
		var callable = Callable(self, localFunction)
		if(textArray.size() == 1): 
			call(localFunction)
		elif hasArguments:
			call(localFunction, arguments)
	else:
		show_error("Command doesn't exist. Use 'help' for more info.")

func print_array(array, color : Color = normalColor, newLine : bool = true):
	for line in array:
		logScreen.append_text("[color=" + color_to_hex(color) + "]")
		logScreen.append_text(line + " ")
		if newLine: logScreen.newline()
		elif (array[array.size() - 1] == line): logScreen.newline() 
		# Just does newline if it's the last element in array

func print_line(line : String, color : Color = normalColor):
	logScreen.append_text("[color=" + color_to_hex(color) + "]")
	logScreen.append_text(line + " ")
	logScreen.newline()

func show_error(error : String, color : Color = errorColor):
#	logScreen.newline()
	print_arrow()
	logScreen.append_text("[color=" + color_to_hex(color) + "]" + error.to_upper() + "[/color]")
	logScreen.newline()

func show_done_message(message : String = "Done!"):
	print_line(message, doneColor)

func print_arrow():
	logScreen.append_text("[color=" + color_to_hex(arrowColor) + "]--> [/color]")
	
func color_to_hex(color : Color) -> String:
	return "#" + color.to_html()

# Check if there's just one argument
func single_argument(arguments : PackedStringArray, justOneErr : bool = false) -> bool:
	if(arguments.size() == 1): return true
	else: 
		if justOneErr: show_error("Just one argument accepted", errorAltColor)
		return false
# Show error for no arguments
func no_arguments(arguments : PackedStringArray, showError : bool = false) -> bool:
	if(arguments.size() == 0): 
		if showError: show_error("No argument recieved", errorAltColor)
		return true
	else: return false
func no_arguments_needed(arguments : PackedStringArray):
	if arguments.size() > 0:
		show_error("This command doesn't allow any arguments.", errorAltColor)

func show_this_help(helpArray : PackedStringArray):
	print_array(helpArray, helpColor)
func is_help(argument : String) -> bool:
	if (argument == "help"): return true
	else: return false

func is_boolean(argument : String):
	if argumentList.has(argument):
		if (argumentList[argument] is bool): return true
		else: return false
func get_boolean(argument : String):
	if !is_boolean(argument): return
	else: return argumentList[argument]
func was_reload_asked_arg2(argument : PackedStringArray) -> bool:
	var reloadScene : bool = false
	if !no_arguments(argument) && argument.size() > 1: 
		var argumentLine = argument[1]
		if (is_boolean(argumentLine)): reloadScene = get_boolean(argumentLine)
	return reloadScene

func reload_scene():
	get_tree().reload_current_scene()
func save_dataDump():
	dataDump.take_over_path(DATA_ROUTE)
	ResourceSaver.save(dataDump, DATA_ROUTE)

func simple_change(argument : PackedStringArray, change : String, doneMessage : String = "Changed sucessfully!"):
	if no_arguments(argument, true): return
	elif is_help(argument[0]): 
		show_this_help(helpReload)
		return
	var reload : bool = was_reload_asked_arg2(argument)
	
	match change:
		'name': playerData.nombre = argument[0]
		'level': 
			if(int(argument[0])): playerData.nivel = int(argument[0])
			else: 
				show_error("Only numbers accepted")
				return
		_: show_error("internal error")

	if reload: reload_scene()
	show_done_message(doneMessage + " " + argument[0])
## ----------- COMMANDS -------------
func help(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_array(helpList, helpColor)
func clear_log(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	logScreen.clear()
# ----
func knowledge_list_to_default(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	playerData.myKnowledgeList = dataDump.KNOWLEDGE_LIST
	show_done_message("Knowledge list from player save file were set to default sucessfully!")
func change_color(argument : PackedStringArray = []):
	if (argument.size() == 0):
		show_error("New color wasn't specify. Check list with 'help'.", errorAltColor)
		return
	var argumentLine = argument[0]
	
	if(argumentList.has(argumentLine)):
		var color : Color = argumentList[argumentLine]
		Utilities.changeFlatboxColor_Panel(logPanel, color)
		show_done_message("Color changed!")
		
		if !single_argument(argument): 
			if argumentList.has(argument[1]) && argumentList[argument[1]] == 'remember':
				dataDump.bgConsoleColor = color
				save_dataDump()
	elif (!is_help(argumentLine)):
		show_error("Not an option... Check help to see list of options.", errorAltColor)
	else:
		show_this_help(helpChangeColor) # HELP
func reload_PlayerData(argument : PackedStringArray = []):
	var reloadScene : bool = false
	
	if !no_arguments(argument): 
		var argumentLine = argument[0]
		if (is_help(argumentLine) ):
			show_this_help(helpReloadData)
			return
		if (is_boolean(argumentLine)): reloadScene = get_boolean(argumentLine)
	
	playerData.take_over_path(SAVE_ROUTE)
	ResourceSaver.save(playerData, SAVE_ROUTE)
	show_done_message("PlayerData reload!")
	if (reloadScene): reload_scene()
func reload_scene_cmmd(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	reload_scene()
func change_name(argument : PackedStringArray = []):
	simple_change(argument, 'name', "Name changed to:")
func change_level(argument : PackedStringArray = []):
	simple_change(argument, 'level', "New level is:")
func show_name(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_line(playerData.nombre, outputColor)
func show_level(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_line(str(playerData.nivel), outputColor)
