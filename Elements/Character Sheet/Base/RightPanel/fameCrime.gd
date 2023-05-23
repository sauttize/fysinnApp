extends HBoxContainer

@export var playerData : PlayerData
@export_category("Label")
@export var raceName : Label

@export var fameNode : Label
@export var crimeNode : Label

func _ready() -> void:
	raceName.text = playerData.raza
	
	fameNode.text = str(playerData.famePercentage)
	crimeNode.text = str(playerData.criminalPercentage)
