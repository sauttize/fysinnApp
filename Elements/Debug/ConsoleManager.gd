extends Node

const SAVE_ROUTE = "User://saves/PlayerSave.tres"
const SAVE_ROUTE_DG = "res://_assets/Scripts/Custom Resources/PlayerSave.tres"
const DATA_ROUTE = "res://_assets/Scripts/Custom Resources/Data/CurrentData.tres"
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@onready var dataDump : DataFile = GameManager.GetDataDump()
@onready var dataDumpOG : DataFile = GameManager.GetDataDump()
@onready var allEffects : Array[Effect] = GameManager.GetAllEffects()

enum STATS {FUE, DES, CON, INT, SAB, CAR, NONE}
var strSTATS : PackedStringArray = ['fue', 'str', 'des','dex', 'con', 'int', 'sab', 'wis', 'car', 'cha']

var commandList : Dictionary = {
	"help": "help",
	"clear": "clear_log",
	"k_default": "knowledge_list_to_default",
	"console_color": "change_color",
	"save": "save_PlayerData_cmm", "save_data": "save_PlayerData_cmm", "savefile": "save_PlayerData_cmm",
	"reload": "reload_scene_cmmd", "reload_s": "reload_scene_cmmd", "re": "reload_scene_cmmd",
	"name": "show_name", "myname": "show_name", "whoami": "show_name",
	"new_name": "change_name", "newname": "change_name", "nameTo": "change_name",
	"level": "show_level", "lvl": 'show_level',
	'last': "last_saved", "lastsave": "last_saved",
	"newlevel": "change_level", 'newlvl': "change_level",
	"d": "throw_dice", "dice": "throw_dice",
	"stat": "show_stat", "st": "show_stat",
	"info": "info_about", "about": "info_about", "i": "info_about",
	"player": "get_player_data", "me": "get_player_data",
	"secret": "easter_egg", "easter_egg": "easter_egg", "rick": "easter_egg", "hack": "easter_egg", "hola": "easter_egg",
	"link": "external_link", "go": "external_link",
	"release": "force_release_mode", "rls": "force_release_mode",
	"sc": "shortcut_list", "short": "shortcut_list", "cut": "shortcut_list", "shortcut": "shortcut_list", "shortcuts": "shortcut_list",
	"add_effect": "add_effect", "newe": "add_effect", "neweffect": "add_effect",
	"effect": "show_effect", "eff" : "show_effect",
	"myeff": "show_active_effects", "myeffects": "show_active_effects", "mye" : "show_active_effects",
	"master": "master_tools"
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
@export var helpInfo : PackedStringArray # info_about
@export var helpShortCuts : PackedStringArray # shortcut_list
@export var helpMaster : PackedStringArray # Master tools
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
@export var releaseVersion : bool = false
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
	
	var arguments : PackedStringArray = []
	
	if(hasArguments):
		for n in (textArray.size() - 1):
			arguments.append(textArray[n + 1])
	if (commandList.has(command)):
		var localFunction : String = commandList[command]
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

func check_args_tooMany(argument : PackedStringArray, tooMany : int = 1, helpCommand : PackedStringArray = ["-"]) -> bool:
	if no_arguments(argument): return false
	elif argument.size() > tooMany: 
		show_error("Too many arguments")
		return true
	if (is_help(argument[0])): 
		show_this_help(helpCommand)
		return true
	return false

func show_this_help(helpArray : PackedStringArray):
	print_array(helpArray, helpColor)
func show_this_help_string(helpString : String):
	print_line(helpString, helpColor)
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
	for n in (reloadArgs.size()):
		if (argument.has(reloadArgs[n])): reloadScene = true
	return reloadScene
func was_save_asked_arg2(argument : PackedStringArray) -> bool:
	if no_arguments(argument) || argument.size() <= 1: return false
	var saveFile : bool = false
	var saveArgs : PackedStringArray = ['-s', 'remember', '-re']
	for n in (saveArgs.size()):
		if (argument.has(saveArgs[n])): saveFile = true
	if saveFile: show_done_message("Data saved!")
	return saveFile
func was_generic_asked(argument : PackedStringArray, searchFor : PackedStringArray, showMsg : bool = false, message : String = "") -> bool:
	if no_arguments(argument): return false
	var wasAsked : bool = false
	for n in (searchFor.size()):
		if (argument.has(searchFor[n])): wasAsked = true
	if wasAsked && showMsg: show_done_message(message)
	return wasAsked

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
	if !OS.is_debug_build(): 
		show_error("Not available in released version.", errorAltColor)
		return
	dataDump.take_over_path(DATA_ROUTE)
	ResourceSaver.save(dataDump, DATA_ROUTE)
func save_playerData():
	playerData.newSave()
	GameManager.UpdateOriginalSaveFile()

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

func get_effect(argument : PackedStringArray):
	var effect : Effect
	var nameGiven : String = ""
	for n in argument.size():
		if argument[n] == "save" || argument[n] == "s": continue
		nameGiven = nameGiven + argument[n]
		if n != argument.size() - 1 && (argument[n + 1] !=  "save" && argument[n + 1] != "s") : 
			nameGiven = nameGiven + ' '
	for effectTemp in allEffects:
		if effectTemp.effectName.to_lower() == nameGiven.to_lower():
			effect = effectTemp
	if effect: return effect
	else: return null

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

func check_path_or_create(path : String):
	DirAccess.make_dir_absolute(path)

## ----------- COMMANDS -------------
# ----------- console related -------------
func help(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_array(helpList, helpColor)
func clear_log(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	logScreen.clear()
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

# ----------- miscelaneous -------------

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

# ----------- modifications -------------
func change_name(argument : PackedStringArray = []):
	simple_change(argument, 'name', "Name changed to:")
	if (was_save_asked_arg2(argument)): save_playerData()
	if (was_reload_asked_arg2(argument)): reload_scene()
func change_level(argument : PackedStringArray = []):
	simple_change(argument, 'level', "New level is:")
	if (was_save_asked_arg2(argument)): save_playerData()
	if (was_reload_asked_arg2(argument)): reload_scene()
func force_release_mode(argument : PackedStringArray = []):
	if check_args_tooMany(argument, 0): return
	releaseVersion = !releaseVersion
	if releaseVersion: show_done_message("Release version mode activated!")
	else: show_done_message("DEBUG version mode activated!")
func add_effect(argument : PackedStringArray = []):
	if no_arguments(argument, true) : return
	var effect : Effect
	if get_effect(argument): effect = get_effect(argument)
	if effect:
		playerData.activeEffects.push_back(effect)
		show_done_message("Effect added! (use eff command to see more details)")
		if was_generic_asked(argument, ["save", "s"], true, "File saved!"): save_playerData()
	else: show_error("That effect doesn't exist.")
# ----------- show stuff -------------
func show_name(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_line("Your current name is: [b]" + playerData.nombre + "[/b]", outputColor)
func show_level(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	print_line("Current level: [b]" + str(playerData.nivel) + "[/b]", outputColor)
func show_stat(argument : PackedStringArray = []):
	if no_arguments(argument, true): return
	if check_args_tooMany(argument, 2, ["Syntax:", "", "stat [stat_name]"]): return
	var stat = get_stat_given(argument)
	
	if stat != STATS.NONE:
		show_done_message("STAT NUMBER: [b]" + str(get_stat_num(stat)) + "[/b]")
		show_done_message("MODIFIER: [b]" + str(get_stat_num(stat, true)) + "[/b]")
func show_effect(argument : PackedStringArray = []):
	if no_arguments(argument, true): return
	var effect : Effect
	if get_effect(argument): effect = get_effect(argument) as Effect
	else: 
		show_error("Effect doesn't exist. Check if name's correct. To see full list use allEffect or alle")
		return
	
	print_line(" ---- EFFECT INFO:", outputColor)
	print_line("[b]Name: [/b]" + effect.effectName, outputColor)
	print_line("[b]Type: [/b]" + effect.effectType, outputColor)
	print_line("[b]Description: [/b]" + effect.effectDescription, outputColor)
	print_line("[b]Nature: [/b]" + effect.effectNature, outputColor)
func show_active_effects(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	
	print_line(" ---- ACTIVE EFFECTS:", outputColor)
	for eff in playerData.activeEffects:
		print_line("[b]" + eff.effectName + "[/b]")
func last_saved(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	
	print_line(" ---- LAST SAVE:", outputColor)
	print_line("[b]Hour: [/b]" + playerData.last_save_hour(), outputColor)
	print_line("[b]Date: [/b]" + playerData.last_save_date(), outputColor)
	print_line("")
	print_line("Current time: " + Time.get_datetime_string_from_system(), outputColor)
func shortcut_list(argument : PackedStringArray = []):
	check_args_tooMany(argument, 0, helpShortCuts)
	show_this_help(helpShortCuts)

# ----------- functionality -------------
func throw_dice(argument : PackedStringArray = []):
	if check_args_tooMany(argument, 3, helpDiceThrow): return
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
func knowledge_list_to_default(argument : PackedStringArray = []):
	no_arguments_needed(argument)
	playerData.myKnowledgeList = dataDump.get_duplicate_list_knowledge()
	show_done_message("Knowledge list from player save file were set to default sucessfully!")

# ----------- information -------------
func get_player_data(argument : PackedStringArray = [], fromInfo : bool = false):
	if fromInfo: check_args_tooMany(argument, 2, ["-"])
	else: check_args_tooMany(argument, 1, ["-"])
	
	# Basic
	print_line("[b]Name: [/b]" + playerData.nombre, outputColor)
	print_line("[b]Level: [/b]" + str(playerData.nivel), outputColor)
	print_line("[b]EXP pts: [/b]" + str(playerData.experiencia), outputColor)
	print_line("[b]Race: [/b]" + str(playerData.raza.name), outputColor)
	print_line("[b]Class: [/b]" + str(playerData.classtype.getString(true)), outputColor)
	print_line("[b]Element: [/b]" + str(playerData.elemento.getString()), outputColor)
	
	if was_generic_asked(argument, ["-s", "full"]):
		print_line("", outputColor)
		print_line("[b]STR: [/b]" + str(playerData.stats.strength) + " ,[b]MOD: [/b]" + str(playerData.stats.strengthMOD), outputColor)
		print_line("[b]DEX: [/b]" + str(playerData.stats.dexterity) + " ,[b]MOD: [/b]" + str(playerData.stats.dexterityMOD), outputColor)
		print_line("[b]CON: [/b]" + str(playerData.stats.constitution) + " ,[b]MOD: [/b]" + str(playerData.stats.constitutionMOD), outputColor)
		print_line("[b]INT: [/b]" + str(playerData.stats.intelligence) + " ,[b]MOD: [/b]" + str(playerData.stats.intelligenceMOD), outputColor)
		print_line("[b]WIS: [/b]" + str(playerData.stats.wisdom) + " ,[b]MOD: [/b]" + str(playerData.stats.wisdomMOD), outputColor)
		print_line("[b]CHA: [/b]" + str(playerData.stats.charisma) + " ,[b]MOD: [/b]" + str(playerData.stats.charismaMOD), outputColor)
	if was_generic_asked(argument, ["-l", "full"]):
		print_line("", outputColor)
		print_line("[b]Current life: [/b]" + str(playerData.currentLife), outputColor)
		print_line("[b]MAX life: [/b]" + str(playerData.maxLife), outputColor)
		print_line("[b]Speed: [/b]" + str(playerData.speed) + "(" + str(playerData.speed / 5) + " blocks)", outputColor)
		print_line("[b]Initiaive Number: [/b]" + str(playerData.initiativeNum), outputColor)
func info_about(argument : PackedStringArray = []):
	if no_arguments(argument, true): return
	if is_help(argument[0]):
		show_this_help(helpInfo)
		return
	
	if was_generic_asked(argument, ["player", "me"]): 
		get_player_data(argument, true)
		return
	
	show_error("Check help to see list of options.")
func external_link(argument : PackedStringArray = []):
	if no_arguments(argument, true): return
	if check_args_tooMany(argument, 2): return
	
	print_line("Opening external link...", doneColor)
	if was_generic_asked(argument, ['aiuda', 'fysinn', 'general', 'home', 'principal', 'a']):
		OS.shell_open('https://www.notion.so/sauttize/Fysinn-9fb53f70d22144b78bde9b8f1086de97')
		return
	if was_generic_asked(argument, ["conocimientos", "con", "knowledge"]):
		OS.shell_open('https://www.notion.so/sauttize/96a2699b4d974fcfab8afc4365f73148?v=ee1058165ec54bf2b4c5026232c3f75d')
		return
	if was_generic_asked(argument, ["tabla", "elementos", "elements", "debilidades", "fortalezas", "elem"]):
		OS.shell_open("https://www.notion.so/sauttize/Elementos-647936ada88a4288b6b326ba6f9a696c")
		return
	if was_generic_asked(argument, ["races", "razas"]):
		OS.shell_open('https://www.notion.so/sauttize/Razas-cb063cf3fd7f45a3abeedff24d897e2d')
		return
	if was_generic_asked(argument, ["draconites", 'draconite',"draco", 'dragones', 'dragon', 'rojos']):
		OS.shell_open('https://www.notion.so/sauttize/Draconites-a94d89e14fb94e33a262124a42bfb72b')
		return
	if was_generic_asked(argument, ["naiad", "naiads", 'sirenas', 'azules', 'vampiros', 'peces']):
		OS.shell_open('https://www.notion.so/sauttize/Naiads-4c131363eefb4d968c3123d64d1d3afb')
		return
	if was_generic_asked(argument, ["duneborn", "arenas", 'naruto', 'chorros', 'tierritas']):
		OS.shell_open('https://www.notion.so/sauttize/Duneborn-18551920b2ba4aada8a9d28d50cacba0')
		return
	if was_generic_asked(argument, ["humanos", "peliblanco", "humano", "aburridos"]):
		OS.shell_open('https://www.notion.so/sauttize/Humanos-259c6d9e95f044ac9d86359ad02f72c2')
		return
	if was_generic_asked(argument, ["raincaster", "raincasters", 'rayitos', 'rayos', 'tss', 'relampagos','lluvias']):
		OS.shell_open('https://www.notion.so/sauttize/Raincasters-380369da3cd34138bf876bfc56bf3bf7')
		return
	if was_generic_asked(argument, ["spells", "hechizos", 'magia', 'magic', 'harry', 'sp', 'harrysosunmago']):
		OS.shell_open('https://www.notion.so/sauttize/ccb9780c015a48149f3fa5ba78be2dcd?v=82469155beec4981bd2c28dae707a5a8')
		return
	if was_generic_asked(argument, ["classes", "clases", 'class', 'clase']):
		OS.shell_open('https://www.notion.so/sauttize/Clases-83b67d58e95b4ae389074bfecaf74943')
		return
	show_error("Search failed! Try another term.")
# ----------- MASTER TOOLS -------------
func master_tools(argument : PackedStringArray = []):
	if was_generic_asked(argument, ["help"]) || no_arguments(argument): show_this_help(helpMaster)
	if was_generic_asked(argument, ["help_bu", "backup"]):
		dataDumpOG.helpList = helpList
		dataDumpOG.helpChangeColor = helpChangeColor
		dataDumpOG.helpSaveFile = helpSaveFile
		dataDumpOG.helpReload = helpReload
		dataDumpOG.helpDiceThrow = helpDiceThrow
		dataDumpOG.helpInfo = helpInfo
		dataDumpOG.helpShortCuts = helpShortCuts
		dataDumpOG.helpMaster = helpMaster
		show_done_message("All arrays were updated and saved!")
# ----------- funsies -------------
func easter_egg(_argument : PackedStringArray = []):
	show_error("No deberias andar husmeando comandos secretos...")
	OS.shell_open('https://youtu.be/dQw4w9WgXcQ')
