extends Control

@export_category("Level Up System")
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@export var levelNumber : SpinBox
@export_category("Level Up Alert")
@export var levelUpAlert : Window
@export var congratPhoto : TextureRect
@export var congratsPhotos : Array[Texture2D]
# Contains exp needed to level up
@export_group("Level up exp")
@export var exp_needed : Array[int] = [0, 300, 900, 2700, 6500, 14000, 23000, 34000, 48000, 64000, 85000, 100000, 120000, 140000, 165000, 195000, 225000, 265000, 305000, 355000] 


func _ready() -> void:
	levelUpAlert.close_requested.connect(levelUpAlert.hide)
	levelUpAlert.visibility_changed.connect(randomize_alert_photo)

#Check if exp to level up was obtained.
func _on_exp_exp_updated():
	var showAlert : bool = false
	for n in range(playerData.nivel, exp_needed.size()):
		if playerData.experiencia >= exp_needed[n]:
			playerData.nivel = (n + 1) # Plus 1 bc is an array and starts in 0.
			showAlert = true
	if showAlert: levelUpAlert.show()
	levelNumber.value = playerData.nivel

func randomize_alert_photo():
	var randNum : int = randi_range(0, congratsPhotos.size() - 1)
	congratPhoto.texture = congratsPhotos[randNum]
	
