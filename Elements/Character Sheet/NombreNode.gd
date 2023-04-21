extends Control

@export var nameLabel : Label

func _on_player_manager_update_all_info(data):
	nameLabel.text = data.nombre
