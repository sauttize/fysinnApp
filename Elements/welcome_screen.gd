extends Control

const DEFAULT_DATA_HOLDER : String = 'user://data/DataContainer.tres'
const DEFAULT_DATA_BACKUP : String = "res://_assets/Scripts/Custom Resources/Data/CurrentData.tres"

const DEFAULT_SAVES_FOLDER : String = 'user://saves/files/'
const DEFAULT_SAVE_FILE : String = 'user://saves/CurrentPlayer.tres'

var saveManager : Array[PlayerData]
var saveFile : PlayerData

@onready var newPlayer : Button = $botones/newSave
@onready var loadPlayer : Button = $botones/loadSave
@onready var manageSaves : Button = $botones/manageSaves
@onready var dmTools : Button = $botones/dmTools

@onready var newPlayerWindow : Window = $"New Player"
@onready var saveManagerWindow : Window = $SaveManager
@onready var saveList : VBoxContainer = $SaveManager/Control/ScrollContainer/partidas
@onready var saveSlot = preload("res://Elements/WelcomeScreen/slot.tscn")

func _ready() -> void:
	check_folders()
	check_data_dump()
	saveManager = GameManager.GetAllSaves()
	check_save_file()
	
	if(saveManager.size() > 0): loadPlayer.disabled = false
	else: loadPlayer.disabled = true
	
	# NewPlayer Window
	newPlayer.pressed.connect(newPlayerWindow.popup_centered_clamped)
	newPlayerWindow.close_requested.connect(update_scene)
	newPlayerWindow.close_requested.connect(newPlayerWindow.hide)
	
	# SaveManager Window
	manageSaves.pressed.connect(saveManagerWindow.popup_centered_clamped)
	manageSaves.pressed.connect(update_saves.bind(true))
	saveManagerWindow.close_requested.connect(saveManagerWindow.hide)

## Check folders and creates them if neccesary
func check_folders():
	if !DirAccess.dir_exists_absolute('user://saves/files/'):
		DirAccess.make_dir_recursive_absolute('user://saves/files/')
	if !DirAccess.dir_exists_absolute('user://data/'):
		DirAccess.make_dir_recursive_absolute('user://data/')
## Check if the current save file exists, if it doesn't, then it'll create a new one empty one.
func check_save_file():
	if (FileAccess.file_exists(DEFAULT_SAVE_FILE)):
		saveFile = ResourceLoader.load(DEFAULT_SAVE_FILE)
	else:
		var newSaveFile = PlayerData.new()
		saveFile = newSaveFile
		ResourceSaver.save(newSaveFile, DEFAULT_SAVE_FILE)
		newSaveFile.take_over_path(DEFAULT_SAVE_FILE)
## Check if the data is loaded, if not takes the back up data from :res
func check_data_dump():
	if (!FileAccess.file_exists(DEFAULT_DATA_HOLDER)):
		var dataBackUp = DataFile.new()
		dataBackUp = ResourceLoader.load(DEFAULT_DATA_BACKUP, 'DataFile')
		ResourceSaver.save(dataBackUp, DEFAULT_DATA_HOLDER)
		dataBackUp.take_over_path(DEFAULT_DATA_HOLDER)

func update_scene():
	get_tree().reload_current_scene()
## //// Save Manager
func update_saves(showEnter : bool = false, showDelete : bool = false):
	for n in saveList.get_children():
		saveList.remove_child(n)
		n.queue_free()
	for s in saveManager:
		var newSlot = saveSlot.instantiate()
		saveList.add_child(newSlot)
		newSlot.set_data(s, showEnter, showDelete)
