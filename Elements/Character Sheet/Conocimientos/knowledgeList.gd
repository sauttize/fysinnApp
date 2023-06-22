extends ItemList

@onready var dataDump : DataFile = GameManager.GetDataDump()
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@export_category("Level Stars")
@export var starContainer : HBoxContainer
var starNodes : Array = []
@export var noLevelColor : Color = Color.ANTIQUE_WHITE
@export var levelColor : Color = Color.CRIMSON

## Basic
var selectedName : String = "Acrobacia"
var selectedKnowl : Knowledge
## NODES TO FILL INFO
@export var perActual : Label
@export var perMinimo : Label
@export var perMaximo : Label

func _ready() -> void:
	get_star_nodes()
	clear()
	clear_level_stars()
	update_list_of_knowledge()
	
	select(0)
	get_knowledge_by_name(selectedName)
	on_item_selected(0)
	
	item_selected.connect(on_item_selected)

## Selected item update
func on_item_selected(index : int):
	selectedName = get_item_text(index)
	get_knowledge_by_name(selectedName)
	update_level_stars(selectedKnowl)
	perActual.text = str(selectedKnowl.currentPercentage)
	perMinimo.text = str(selectedKnowl.minPercentage)
	perMaximo.text = str(selectedKnowl.maxPercentage)

## Updates all knowledges
func update_list_of_knowledge():
	for k in playerData.myKnowledgeList:
		add_item(k.knowledgeName)

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

## Functionality
func get_knowledge_by_name(name : String):
	for k in playerData.myKnowledgeList:
		if k.return_by_name(selectedName):
			selectedKnowl = k
			return
