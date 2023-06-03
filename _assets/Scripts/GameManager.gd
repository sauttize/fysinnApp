extends Node

#const TEMP_FILE = "res://_assets/Scripts/Custom Resources/temp.tres"
const SAVE_ROUTE = "res://_assets/Scripts/Custom Resources/PlayerSave.tres"

var save_file_path = "res://_assets/Scripts/Custom Resources/"
var save_file_name = "PlayerSave.tres"
var load_file_tmp = "temp.tres"

@export var _playerData : PlayerData
var playerData = PlayerData.new()

@export var smallerWindow : bool = false

var saving : bool = false

func _ready():
	verify_save_directory(save_file_path)
	_playerData = get_file(_playerData)
	
	if smallerWindow:
		var smallerSize = Vector2i(600, 700)
		get_window().size = smallerSize
		
		var screenSize = DisplayServer.screen_get_size()
		var windowSize = get_window().size
		var centerX = (screenSize.x - windowSize.x) / 2
		var centerY = (screenSize.y - windowSize.y) / 2
		var centerPos = Vector2i(centerX, centerY)
		
		get_window().position = Vector2i(centerPos)

func save_file():
	_playerData.newSave()
	ResourceSaver.save(_playerData, save_file_path + save_file_name)
	
func save_and_reload():
	save_file()

#In case PlayerData is losted.
func get_file(data):
	if (!data):
		return ResourceLoader.load(SAVE_ROUTE)
	else:
		return data

# If it doesnt exist, it creates it.
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

#MenuBar Options
func _on_menu_bar_save_file():
	$SaveResource.popup_centered_clamped()

func _on_menu_bar_load_file():
	$LoadResource.popup_centered_clamped()

# SAVE FILE FROM MENU
func _on_menu_bar_re_save_file():
	save_and_reload()

# SAVE NEW FILE
func _on_save_resource_file_selected(save_path):
	_playerData.newSave()
	ResourceSaver.save(_playerData, save_path)

# LOAD FILE FROM DISK
func _on_load_resource_file_selected(load_path):
	playerData = ResourceLoader.load(load_path).duplicate(true)
	playerData.newSave()
	playerData.take_over_path(SAVE_ROUTE)
	ResourceSaver.save(playerData, SAVE_ROUTE)
	
	get_tree().reload_current_scene()
	#updateAllInfo.emit()
	#updateSaveFile.emit()

