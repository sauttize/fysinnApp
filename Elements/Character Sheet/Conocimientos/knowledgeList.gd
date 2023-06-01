extends ItemList

var dataDump : DataFile = preload("res://_assets/Scripts/Custom Resources/Data/CurrentData.tres")
@export_category("Level Stars")
@export var starContainer : HBoxContainer
var starNodes : Array = []
@export var noLevelColor : Color = Color.ANTIQUE_WHITE
@export var levelColor : Color = Color.CRIMSON

func _ready() -> void:
	get_star_nodes()
	clear()
	clear_level_stars()

## Updates all knowledges
func get_list_of_knowledge():
	pass

## Stars
func get_star_nodes():
	starNodes = starContainer.get_children()

func update_level_stars(knowl : Knowledge):
	clear_level_stars()
	var level = knowl.currentLevel
	for n in level:
		starNodes[n].modulate = levelColor

func clear_level_stars():
	for star in starNodes:
		star.modulate = noLevelColor
