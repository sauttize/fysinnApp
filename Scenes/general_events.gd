extends Node
class_name GeneralEvents

@export var arrayButtons : Array[Button]

func _ready() -> void:
	arrayButtons[0].pressed.connect(change_to_default_size) 

func change_to_default_size():
	Utilities.resize_window(Vector2i(700, 900))

