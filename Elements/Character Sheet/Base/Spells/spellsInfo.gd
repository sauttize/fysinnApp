extends Control

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@export_category("Dependencies")
@export_subgroup("Variables")
@export var casillasNumber : Label
@export var velocityNumber : Label
@export var initiativeNumber : Label

func _ready() -> void:
	casillasNumber.text = str(playerData.casillasMov)
	velocityNumber.text = str(playerData.speed)
	initiativeNumber.text = str(playerData.initiativeNum)

