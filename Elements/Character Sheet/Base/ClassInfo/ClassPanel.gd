extends Control

@export var playerData : PlayerData = preload("res://_assets/Scripts/Custom Resources/PlayerSave.tres")
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
	className.text = "Clase: " + classType.getString().replacen("_", " ")

func setClassColors():
	#panel
	var new_stylebox_panel = namePanel.get_theme_stylebox("panel").duplicate()
	new_stylebox_panel.bg_color = classType.primaryColor
	namePanel.add_theme_stylebox_override("panel", new_stylebox_panel)
	
	#label
	className.add_theme_color_override("font_color", classType.secundaryColor)
