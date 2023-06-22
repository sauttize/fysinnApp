extends MenuButton

@onready var thisScene = $"../../../../.."
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

signal saveFile #Guardar como...
signal reSaveFile #Guardar
signal loadFile

var popup

func _ready():
	popup = get_popup()
	popup.id_pressed.connect(_on_item_pressed)

func _on_item_pressed(id: int):
		if (id == 0): emit_signal("saveFile")
		elif (id == 1): emit_signal("loadFile")
		elif (id == 3): emit_signal("reSaveFile")
		elif (id == 2):
			thisScene.queue_free()
			get_tree().change_scene_to_file("res://Elements/welcome_screen.tscn")
