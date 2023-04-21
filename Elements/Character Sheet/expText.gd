extends Label

@export var player_data : PlayerData

func _ready():
	text = str(player_data.exp)

func _on_exp_window_visibility_changed():
	if player_data:
		text = str(player_data.exp)
