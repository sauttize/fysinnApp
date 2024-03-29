extends Control

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
var classType : ClassType

@export_category("Nodes")
@export_subgroup("Visuals")
@export var className : Label
@export var namePanel : Panel

func _ready() -> void:
	classType = playerData.classtype
	
	setClassColors()
	setName()

func setName():
	className.text = "Clase: " + classType.getString(true, true)

func setClassColors():
	#panel
	Utilities.changeFlatboxColor_Panel(namePanel, classType.primaryColor)
	#label
	Utilities.changeFontColor_Label(className, classType.secundaryColor)
