extends Label

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

func _ready():
	update_data()

func update_data():
	text = playerData.nombre

# Changes name but only when the pop up was closed.
func _on_name_window_visibility_changed():
	update_data()
	

