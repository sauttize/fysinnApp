extends MenuButton

@export var player_data : PlayerData

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
