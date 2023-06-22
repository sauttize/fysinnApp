extends SpinBox

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

func _ready():
	update_data()
	
func update_data():
	value = playerData.nivel

func _on_nivel_level_up():
	update_data()
