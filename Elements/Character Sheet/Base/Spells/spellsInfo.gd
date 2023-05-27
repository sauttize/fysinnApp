extends Control

@export var playerData : PlayerData
@export_category("Dependencies")
@export_subgroup("Variables")
@export var actionPointsNumber : Label
@export var velocityNumber : Label
@export var initiativeNumber : Label

func _ready() -> void:
	actionPointsNumber.text = str(playerData.actionPoints)
	velocityNumber.text = str(playerData.velocity)
	initiativeNumber.text = str(playerData.initiativeNum)

