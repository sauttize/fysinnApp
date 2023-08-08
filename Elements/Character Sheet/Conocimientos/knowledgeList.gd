extends ItemList
class_name KnowledgeList

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
@export_category("Information nodes")
@export_subgroup("Percentage")
@export var perActual : Label
@export var perMinimo : Label
@export var perMaximo : Label
@export_subgroup("Middle row")
@export var description_label : RichTextLabel
@export var failed_attempts : Label
@export var current_motivation : Label
@export_subgroup("Bottom row")
@export var associated_stat : Label
@export var proficiency_type : OptionButton
@export var list_effects : Label
@export var effect_bttn : Button

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
	
	update_information()

## Updates every node
func update_information() -> void:
	if !selectedKnowl:
		Utilities.create_PopUp("No hay concimiento asociado...")
		return
	else:
		perActual.text = str(selectedKnowl.currentPercentage)
		perMinimo.text = str(selectedKnowl.minPercentage)
		perMaximo.text = str(selectedKnowl.maxPercentage)
		
		description_label.clear()
		description_label.append_text(selectedKnowl.description)
		failed_attempts.text = str(selectedKnowl.failAttempts)
		current_motivation.text = str(selectedKnowl.motivation)
		
		if selectedKnowl.associatedStat:
			associated_stat.text = Stats.new().get_string(selectedKnowl.associatedStat)
			var stat_mod = playerData.stats.get_mod(selectedKnowl.associatedStat)
			associated_stat.text += " (+%s)" % [stat_mod]
		else:
			associated_stat.text = "--"
		
		match selectedKnowl.get_proficiency_string():
			"NONE":
				proficiency_type.select(0)
			"PROFICIENCY":
				proficiency_type.select(1)
			"HALF_PROFICIENCY":
				proficiency_type.select(2)
			"EXPERTISE":
				proficiency_type.select(3)
		
		list_effects.text = ""
		if selectedKnowl.associatedEffects.size() != 0:
			effect_bttn.disabled = false
			for eff in selectedKnowl.associatedEffects:
				list_effects.text += "- %s\n" % [eff.effectName] 
		else:
			effect_bttn.disabled = true


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
func get_knowledge_by_name(name_search : String):
	for k in playerData.myKnowledgeList:
		if k.return_by_name(name_search):
			selectedKnowl = k
			return
