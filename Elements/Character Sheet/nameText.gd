extends Label

@export var player_data : PlayerData

func _ready():
	update_data()

func update_data():
	text = player_data.nombre

# Changes name but only when the pop up was closed.
func _on_name_window_visibility_changed():
	update_data()
	

