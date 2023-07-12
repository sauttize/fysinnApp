extends Node

@export var window_size : Vector2i = Vector2i(700, 900)

func _ready() -> void:
	Utilities.resize_window(window_size)
