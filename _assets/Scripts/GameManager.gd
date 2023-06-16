extends Node

const DATA_DUMP_ROUTE = "user://data/DataContainer.tres"
const DATA_DUMP_BACKUP = "res://_assets/Scripts/Custom Resources/Data/CurrentData.tres"

const SAVES_FOLDER_ROUTE = "user://saves/files/"
const SAVE_ROUTE = "user://saves/CurrentPlayer.tres"

var save_file_path = "user://saves/"
var save_file_path_dg = "res://_assets/Scripts/Custom Resources/"

@onready var _playerData : PlayerData = GetCurrentSaveFile()
#@onready var _saveManager : SaveFilesManager = GetManager()

var saving : bool = false

func _init() -> void:
	verify_save_directory(save_file_path)
#	if !OS.is_debug_build(): verify_save_file(SAVE_ROUTE, true)

func save_file():
#	_playerData.newSave()
	ResourceSaver.save(_playerData, SAVE_ROUTE)

# If it doesnt exist, it creates it.
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
func verify_save_file(path : String, createFile : bool = false):
	if FileAccess.file_exists(path): return true
	elif createFile:
		print("save file created because it didn't exist")
		save_file()
	print(DirAccess.get_open_error())
	return false

#MenuBar Options
func _on_menu_bar_save_file():
	$SaveResource.popup_centered_clamped()

func _on_menu_bar_load_file():
	$LoadResource.popup_centered_clamped()

# SAVE FILE FROM MENU
func _on_menu_bar_re_save_file():
	save_file()

# SAVE NEW FILE IN CUSTOM PATH
func _on_save_resource_file_selected(save_path):
	_playerData.newSave()
	ResourceSaver.save(_playerData, save_path)

# LOAD FILE FROM DISK
func _on_load_resource_file_selected(load_path):
	var playerData = ResourceLoader.load(load_path).duplicate(true)
	playerData.newSave()
	playerData.take_over_path(SAVE_ROUTE)
	ResourceSaver.save(playerData, SAVE_ROUTE)
	
	get_tree().reload_current_scene()

func GetCurrentSaveFile() -> PlayerData:
	if !verify_save_file(SAVE_ROUTE, true): return PlayerData.new()
	var currentSave = ResourceLoader.load(SAVE_ROUTE)
	return currentSave

func GetAllSaves() -> Array[PlayerData]:
	var allSaves : Array[PlayerData] = []
	var pathList : PackedStringArray = DirAccess.get_files_at(SAVES_FOLDER_ROUTE)
	pathList = updatePathList(pathList)
	for path in pathList:
		var playerData
		playerData = ResourceLoader.load(path)
		if playerData is PlayerData:
			allSaves.push_back(playerData)
	return allSaves

func updatePathList(array : PackedStringArray) -> PackedStringArray:
	for n in array.size():
		array[n] = SAVES_FOLDER_ROUTE + array[n]
	return array

func GetDataDump() -> DataFile:
	var getDataDump : DataFile
	if !verify_save_file(DATA_DUMP_ROUTE): 
		getDataDump = ResourceLoader.load(DATA_DUMP_BACKUP)
	else:
		getDataDump = ResourceLoader.load(DATA_DUMP_ROUTE)
	return getDataDump

func UpdateCurrentPD(data : PlayerData):
	ResourceSaver.save(data, SAVE_ROUTE)
	data.take_over_path(SAVE_ROUTE)
