extends Control

const DEFAULT_SAVE_MANAGER : String = 'user://saves/SaveFiles.tres'
const DEFAULT_SAVE_FILE : String = 'user://saves/CurrentPlayer.tres'

var saveManager : SaveFilesManager
var saveFile : PlayerData

@onready var newPlayer : Button = $botones/newSave
@onready var loadPlayer : Button = $botones/loadSave
@onready var manageSaves : Button = $botones/manageSaves
@onready var dmTools : Button = $botones/dmTools

@onready var newPlayerWindow : Window = $"New Player"
@onready var saveManagerWindow : Window = $SaveManager

func _ready() -> void:
	check_save_manager()
	check_save_file()
	
	if(saveManager.numberOfSaves > 1): loadPlayer.disabled = false
	else: loadPlayer.disabled = true
	
	# NewPlayer Window
	newPlayer.pressed.connect(newPlayerWindow.popup_centered_clamped)
	newPlayerWindow.close_requested.connect(newPlayerWindow.hide)
	
	# SaveManager Window
	manageSaves.pressed.connect(saveManagerWindow.popup_centered_clamped)
	saveManagerWindow.close_requested.connect(saveManagerWindow.hide)

## Check if the manager exists, if it doesn't, then it'll create a new empty one.
func check_save_manager():
	if (FileAccess.file_exists(DEFAULT_SAVE_MANAGER)):
		saveManager = ResourceLoader.load(DEFAULT_SAVE_MANAGER)
	else:
		var newSaveManager = SaveFilesManager.new()
		saveManager = newSaveManager
		ResourceSaver.save(newSaveManager, DEFAULT_SAVE_MANAGER)
		newSaveManager.take_over_path(DEFAULT_SAVE_MANAGER)
## Check if the current save file exists, if it doesn't, then it'll create a new one empty one.
func check_save_file():
	if (FileAccess.file_exists(DEFAULT_SAVE_FILE)):
		saveFile = ResourceLoader.load(DEFAULT_SAVE_FILE)
	else:
		var newSaveFile = PlayerData.new()
		saveFile = newSaveFile
		ResourceSaver.save(newSaveFile, DEFAULT_SAVE_FILE)
		newSaveFile.take_over_path(DEFAULT_SAVE_FILE)
