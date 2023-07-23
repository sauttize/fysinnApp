extends Label

@onready var player_data : PlayerData = GameManager.GetCurrentSaveFile()

func _ready():
	text = str(player_data.experiencia)

func _on_exp_window_visibility_changed():
	if player_data:
		text = str(player_data.experiencia)
