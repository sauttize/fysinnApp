extends Node

const SAVE_ROUTE = "res://_assets/Scripts/Custom Resources/PlayerSave.tres"
const DATA_ROUTE = "res://_assets/Scripts/Custom Resources/Data/CurrentData.tres"
var playerData : PlayerData = preload("res://_assets/Scripts/Custom Resources/PlayerSave.tres")
var dataDump : DataFile = preload("res://_assets/Scripts/Custom Resources/Data/CurrentData.tres")

enum STATS {FUE, DES, CON, INT, SAB, CAR, NONE}
var strSTATS : PackedStringArray = ['fue', 'str', 'des','dex', 'con', 'int', 'sab', 'wis', 'car', 'cha']

var commandList : Dictionary = {
	"help": "help",
	"clear": "clear_log",
	"k_default": "knowledge_list_to_default",
	"console_color": "change_color",
	"save_data": "save_PlayerData_cmm", "savefile": "save_PlayerData_cmm",
	"reload": "reload_scene_cmmd", "reload_s": "reload_scene_cmmd",
	"name": "show_name", "myname": "show_name", "whoami": "show_name",
	"new_name": "change_name", "newname": "change_name", "nameTo": "change_name",
	"level": "show_level",
	'last': "last_saved", "lastsave": "last_saved",
	"newlevel": "change_level",
	"d": "throw_dice", "dice": "throw_dice",
	"stat": "show_stat"
}

@onready var argumentList : Dictionary = {
	'default': bgColors[0], 'black': bgColors[0],
	'blue': bgColors[1], 'azul': bgColors[1],
	'pink': bgColors[2], 'rosa': bgColors[2],
	'green': bgColors[3], 'verde': bgColors[3],
	'purple': bgColors[4], 'violeta': bgColors[4],
	'true': true, '-y': true, 'reload': true, '-r': true,
	'false': false, '-n': false,
	'remember': 'remember', "-re": 'remember', "-s": "remember"
}

@onready var inputLine : LineEdit = $consoleElements/writeLine
@onready var logScreen : RichTextLabel = $consoleElements/logPanel/consoleLog
@onready var logPanel : Panel = $consoleElements/logPanel
@export_category("Config")
@export_subgroup("Help lists")
@export var helpList : PackedStringArray # General
@export var helpChangeColor : PackedStringArray # change_color
@export var helpSaveFile : PackedStringArray # reload_PlayerData
@export var helpReload : PackedStringArray # to any function that implements reload
@export var helpDiceThrow : PackedStringArray # dice_throw
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
@export_category("Functionality")
@export_range(1, 50) var MAX_DICE_MULTIPLIER : int = 20

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
		show_error("Command doesn't exist. Use 'help' for more info.", errorColor)

func print_array(array, color : Color = normalColor, newLine : bool = true):
	for line in array:
		logScreen.push_color(color)
#		logScreen.append_text("[color=" + color_to_hex(color) + "]")
		logScreen.append_text(line + " ")
		if newLine: logScreen.newline()
	if !newLine: logScreen.newline() 
	logScreen.push_color(normalColor)
	# Just does newline if it's the last element in array

func print_line(line : String, color : Color = normalColor):
	logScreen.push_color(color)
#	logScreen.append_text("[color=" + color_to_hex(color) + "]")
	logScreen.append_text(line + " ")
	logScreen.newline()
	logScreen.push_color(normalColor)

func show_error(error : String, color : Color = errorAltColor):
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
		if justOneErr: show_error("Just one argument accepted")
		return false
# Show error for no arguments
func no_arguments(arguments : PackedStringArray, showError : bool = false) -> bool:
	if(arguments.size() == 0): 
		if showError: show_error("No argument recieved")
		return true
	else: return false
func no_arguments_needed(arguments : PackedStringArray):
	if arguments.size() > 0:
		show_error("This command doesn't allow any arguments.")

func check_args_tooMany(argument : PackedStringArray, helpCommand : PackedStringArray = ["-"], tooMany : int = 1) -> bool:
	if no_arguments(argument): return false
	elif argument.size() > tooMany: show_error("Too many arguments")
	if (is_help(argument[0])): 
		show_this_help(helpCommand)
		return false
	return true

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
## Check for -r flag from arg2 and so on.
func was_reload_asked_arg2(argument : PackedStringArray) -> bool:
	if no_arguments(argument) || argument.size() <= 1: return false
	var reloadScene : bool = false
	var reloadArgs : PackedStringArray = ['-r', 'reload']
	for n in (reloadArgs.size() - 1):
		if (argument.has(reloadArgs[n])): reloadScene = true
	return reloadScene
func was_save_asked_arg2(argument : PackedStringArray) -> bool:
	if no_arguments(argument) || argument.size() <= 1: return false
	var saveFile : bool = false
	var saveArgs : PackedStringArray = ['-s', 'remember', '-re']
	for n in (saveArgs.size() - 1):
		if (argument.has(saveArgs[n])): saveFile = true
	if saveFile: show_done_message("Data saved!")
	return saveFile
func get_stat_given(argument : PackedStringArray) -> STATS:
	if no_arguments(argument): return STATS.NONE
	for arg in argument:
		if strSTATS.has(arg.to_lower()):
			match arg.to_lower():
				'str', 'fue':
					return STATS.FUE
				'des', 'dex':
					return STATS.DES
				'con':
					return STATS.CON
				'int':
					return STATS.INT
				'sab', 'wis':
					return STATS.SAB
				'car', 'cha':
					return STATS.CAR
				_: 
					return STATS.NONE
	return STATS.NONE

func reload_scene():
	get_tree().reload_current_scene()
func save_dataDump():
	playerData.newSave()
	dataDump.take_over_path(DATA_ROUTE)
	ResourceSaver.save(dataDump, DATA_ROUTE)
func save_playerData():
	playerData.take_over_path(SAVE_ROUTE)
	ResourceSaver.save(playerData, SAVE_ROUTE)

func get_stat_num(stat : STATS, getMod : bool = false) -> int:
	match stat:
		STATS.FUE:
			if getMod: return playerData.stats.strengthMOD
			else: return playerData.stats.strength
		STATS.DES:
			if getMod: return playerData.stats.dexterityMOD
			else: return playerData.stats.dexterityMOD
		STATS.CON:
			if getMod: return playerData.stats.constitutionMOD
			else: return playerData.stats.constitution
		STATS.INT:
			if getMod: return playerData.stats.intelligenceMOD
			else: return playerData.stats.intelligence
		STATS.SAB:
			if getMod: return playerData.stats.wisdomMOD
			else: return playerData.stats.wisdom
		STATS.CAR:
			if getMod: return playerData.stats.charismaMOD
			else: return playerData.stats.charisma
		_:
			return 1313

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
				show_done_message("[i]... and saved![/i]")
				save_dataDump()
	elif (!is_help(argumentLine)):
		show_error("Not an option... Check help to see list of options.", errorAltColor)
	else:
		show_this_help(helpChangeColor) # HELP
func save_PlayerData_cmm(argument : PackedStringArray = []):
	if !no_arguments(argument): 
		var argumentLine = argument[0]
		if (is_help(argumentLine) ):
			show_this_help(helpSaveFile)
			return
	save_playerData()
	show_done_message("PlayerData saved!")
	if (was_reload_asked_arg2(argument)): reload_scene()
func reload_scene_cmmd(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	reload_scene()
func change_name(argument : PackedStringArray = []):
	simple_change(argument, 'name', "Name changed to:")
	if (was_save_asked_arg2(argument)): save_playerData()
	if (was_reload_asked_arg2(argument)): reload_scene()
func change_level(argument : PackedStringArray = []):
	simple_change(argument, 'level', "New level is:")
	if (was_save_asked_arg2(argument)): save_playerData()
	if (was_reload_asked_arg2(argument)): reload_scene()
func show_name(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_line("Your current name is: [b]" + playerData.nombre + "[/b]", outputColor)
func show_level(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_line("Current level: [b]" + str(playerData.nivel) + "[/b]", outputColor)
func show_stat(argument : PackedStringArray = []):
	if no_arguments(argument, true): return
	if !check_args_tooMany(argument, ["Syntax:", "", "stat [stat_name]"], 2): return
	var stat = get_stat_given(argument)
	var getMOD : bool = false
	
	if stat != STATS.NONE:
		show_done_message("STAT NUMBER: [b]" + str(get_stat_num(stat)) + "[/b]")
		show_done_message("MODIFIER: [b]" + str(get_stat_num(stat, true)) + "[/b]")
func last_saved(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_line("Last save data: [i]" + playerData.lastSaved + "[/i]", outputColor)

# |||||| FUNCTIONALITY |||||||
func throw_dice(argument : PackedStringArray = []):
	if !check_args_tooMany(argument, helpDiceThrow, 3): return
	if no_arguments(argument, true): return
	var allowedDices = ['4', '8', '10', '12', '20']
	if !allowedDices.has(argument[0]): 
		show_error("Not a dice type!", errorAltColor)
		return
	var dice : int = int(argument[0])
	var total : int = 0
	var addStat : bool = false
	var stat : STATS = STATS.NONE
	
	var rng = RandomNumberGenerator.new()
	var multiplier : int = 1
	if argument.size() > 1:
		if int(argument[1]):
			var num : int = int(argument[1])
			if num > MAX_DICE_MULTIPLIER:
				show_error("You can only throw " + str(MAX_DICE_MULTIPLIER) + " times.", errorAltColor)
			elif (num < 1): show_error("Multiplier should be at least 2. [i](1 is by default)[/i]", errorAltColor)
			multiplier = clamp(num, 1, MAX_DICE_MULTIPLIER)
			
		stat = get_stat_given(argument)
		if (stat != STATS.NONE): addStat = true
	
	for n in multiplier:
		var randomNum : int = rng.randi_range(1,dice)
		total = total + randomNum
		print_line(str(randomNum), outputColor)
	if addStat: total = total + get_stat_num(stat, true)
	
	print_line("")
	print_line("Total: [b]" + str(total) + "[/b]", doneColor)
