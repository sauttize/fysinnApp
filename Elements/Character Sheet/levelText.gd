extends SpinBox

@export var player_data : PlayerData

func _ready():
	update_data()
	
func update_data():
	value = player_data.nivel

func _on_nivel_level_up():
	update_data()
