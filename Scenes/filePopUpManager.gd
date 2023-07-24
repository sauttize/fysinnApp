extends MenuButton

@onready var thisScene = $"../../../../.."
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@export var loadWindow : FileDialog
@export var saveWindow : FileDialog


var popup

func _ready():
	popup = get_popup()
	popup.id_pressed.connect(_on_item_pressed)
	
	loadWindow.file_selected.connect(GameManager._on_load_resource_file_selected)
	saveWindow.file_selected.connect(GameManager._on_save_resource_file_selected)
	
	loadWindow.close_requested.connect(loadWindow.hide)
	saveWindow.close_requested.connect(saveWindow.hide)

func _on_item_pressed(id: int):
		if (id == 0): # Save
			saveWindow.show()
		elif (id == 1): # Load
			pass
		elif (id == 3): 
			GameManager.UpdateOriginalSaveFile()
			Utilities.create_PopUp("¡Partida guardada!")
		elif (id == 2):
			thisScene.queue_free()
			get_tree().change_scene_to_file("res://Elements/welcome_screen.tscn")
