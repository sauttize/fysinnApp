extends Node

var playerData : PlayerData = preload("res://_assets/Scripts/Custom Resources/PlayerSave.tres")
var dataDump : DataFile = preload("res://_assets/Scripts/Custom Resources/Data/CurrentData.tres")

var commandList : Dictionary = {
	"help": "help",
	"clear": "clear_log",
	"k_default": "knowledge_list_to_default",
	"consoleColorTo": "changeColor"
}

@onready var inputLine : LineEdit = $consoleElements/writeLine
@onready var logScreen : RichTextLabel = $consoleElements/logPanel/consoleLog
@export var helpList : PackedStringArray
@export_category("Colors")
@export var normalColor : Color = Color.ANTIQUE_WHITE
@export var arrowColor : Color
@export var outputColor : Color
@export var doneColor : Color
@export var errorColor : Color = Color.RED

func _ready() -> void:
	inputLine.text_submitted.connect(get_text)
	
func get_text(textSubmitted : String):
	var textArray : PackedStringArray = textSubmitted.rsplit(" ")
	inputLine.clear()
	print_arrow()
	print_array(textArray)
	check_command(textArray)

func check_command(textArray : PackedStringArray):
	if (commandList.has(textArray[0])):
		call(commandList[textArray[0]])
	else:
		show_error("Command doesn't exist. Use 'help' for more info.")

func print_array(array, color : Color = normalColor):
	for line in array:
		logScreen.append_text("[color=" + color_to_hex(color) + "]")
		logScreen.append_text(line + " ")
		logScreen.newline()
#		logScreen.append_text("[/color]")

func print_line(line : String, color : Color = normalColor):
	logScreen.append_text("[color=" + color_to_hex(color) + "]")
	logScreen.append_text(line + " ")
	logScreen.newline()

func show_error(error : String):
#	logScreen.newline()
	print_arrow()
	logScreen.append_text("[color=" + color_to_hex(errorColor) + "]" + error.to_upper() + "[/color]")
	logScreen.newline()

func show_done_message(message : String = "Done!"):
	print_line(message, doneColor)

func print_arrow():
	logScreen.append_text("[color=" + color_to_hex(arrowColor) + "]--> [/color]")
	
func color_to_hex(color : Color) -> String:
	return "#" + color.to_html()

## ----------- COMMANDS -------------
func help():
	print_array(helpList, outputColor)
func clear_log():
	logScreen.clear()
func knowledge_list_to_default():
	playerData.myKnowledgeList = dataDump.KNOWLEDGE_LIST
	show_done_message("Knowledge list from player save file were set to default sucessfully!")
