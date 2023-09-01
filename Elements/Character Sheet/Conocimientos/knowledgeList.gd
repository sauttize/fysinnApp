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
## NODES WITH ACTION
@export_category("Action nodes")
@export_subgroup("Special Throw")
@export var special_button : Button
@export var learn_button : Button
@export var learn_win : Window
@export var learn_win_bttn1 : Button
@export var learn_win_options : OptionButton
@export var learn_win_bttn2 : Button
@export var learn_win_bttn3 : Button
@export_subgroup("Special Throw/Screens")
@export var learn_win_screen1: VBoxContainer
@export var learn_win_screen2: VBoxContainer
@export_subgroup("Stat Throw")
@export var stat_button : Button
@export var effect_bttn : Button
@export var stat_t_win : Window
@export var stat_win_control : VBoxContainer
@export var stat_win_anim : Control
@export var stat_anim_controller : AnimationPlayer
@export var stat_win_spin : SpinBox
@export var stat_win_button : Button
@export var stat_anim_time : float = 0.5
signal update_history
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

func _ready() -> void:
	# General
	get_star_nodes()
	clear()
	clear_level_stars()
	update_list_of_knowledge()
	
	select(0)
	get_knowledge_by_name(selectedName)
	on_item_selected(0)
	
	item_selected.connect(on_item_selected)
	owner.visibility_changed.connect(full_update)
	
	# Learn
	learn_button.pressed.connect(learn_win.show)
	learn_win.close_requested.connect(learn_win.hide)
	learn_win_bttn1.pressed.connect(change_screens.bind(1))
	learn_win_bttn3.pressed.connect(change_screens.bind(2))
	
	learn_win_bttn2.pressed.connect(learn_knowledge)
	
	# Special throw
	special_button.pressed.connect(on_special_throw)
	
	# Stat throw
	stat_t_win.close_requested.connect(stat_t_win.hide)
	stat_button.pressed.connect(stat_t_win.show)
	stat_win_button.pressed.connect(on_stat_throw)
	
	# Others
	proficiency_type.item_selected.connect(update_proficiency)

func full_update() -> void:
	get_knowledge_by_name(selectedName)
	update_level_stars(selectedKnowl)
	
	update_information()

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
		
		if selectedKnowl.currentLevel == 10: learn_button.disabled = true
		else: learn_button.disabled = false
		
		description_label.clear()
		description_label.append_text(selectedKnowl.description)
		description_label.newline()
		description_label.append_text("[b]Usos consecutivos: [/b] %s" % [selectedKnowl.max_throw_num])
		failed_attempts.text = str(selectedKnowl.failAttempts)
		current_motivation.text = str(selectedKnowl.motivation)
		
		if selectedKnowl.associatedStat != Stats.STATS.NONE:
			associated_stat.text = Stats.get_string(selectedKnowl.associatedStat)
			var stat_mod = playerData.stats.get_mod(selectedKnowl.associatedStat)
			associated_stat.text += " (+%s)" % [stat_mod]
			stat_button.disabled = false
		else:
			associated_stat.text = "--"
			stat_button.disabled = true
		
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

func update_proficiency(index : int) -> void:
	match proficiency_type.get_item_text(index):
		"Normal":
			selectedKnowl.proficiencyType = Knowledge.PROFICIENCY.PROFICIENCY
		"Half":
			selectedKnowl.proficiencyType = Knowledge.PROFICIENCY.HALF_PROFICIENCY
		"Expertise":
			selectedKnowl.proficiencyType = Knowledge.PROFICIENCY.EXPERTISE
		_:
			selectedKnowl.proficiencyType = Knowledge.PROFICIENCY.NONE

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

## Learn
func change_screens(index : int) -> void:
	if index == 1:
		learn_win_screen1.hide()
		learn_win_screen2.show()
	else:
		learn_win_screen2.hide()
		learn_win_screen1.show()

func learn_knowledge() -> void:
	var learn_op : int = learn_win_options.selected
	var learn_type : GameTools.K_TYPE
	var learn_type_str : String
	
	if learn_op == 0: 
		learn_type = GameTools.K_TYPE.PRACTICE
		learn_type_str = "Practica"
	elif learn_op == 1: 
		learn_type = GameTools.K_TYPE.BOOK
		learn_type_str = "Objeto"
	else: 
		learn_type = GameTools.K_TYPE.ACADEMY
		learn_type_str = "Academia"
	
	var record = GameTools.knowledge_learn(selectedKnowl, learn_type, learn_type_str)
	
	playerData.knowl_history.append(record)
	update_history.emit()
	update_information()
	update_level_stars(selectedKnowl)

## Special throw
func on_special_throw() -> void:
	if selectedKnowl && selectedKnowl.motivation >= selectedKnowl.fail_lose:
		var special_throw := selectedKnowl.special_throw()
		var new_report = KnowledgeRecord.new()
		new_report.create_special_record(selectedKnowl, special_throw)
		playerData.knowl_history.append(new_report)
		update_history.emit()
		update_information()
	else:
		Utilities.create_PopUp("No tienes suficiente motivación. Necesitas al menos %s!" % selectedKnowl.fail_lose)

## Stat throw
func on_stat_throw() -> void:
	if selectedKnowl && selectedKnowl.associatedStat != Stats.STATS.NONE:
		# Numbers
		var add_mod : int = playerData.stats.get_mod(selectedKnowl.associatedStat)
		var d20_throw : int = randi_range(1, 20) # Simulating dice throw
		var got_num : int = d20_throw + add_mod + get_proficiency(selectedKnowl)
		var needed_num : int = stat_win_spin.value
		stat_win_control.hide()
		stat_win_anim.show()
		stat_anim_controller.play("dice_movement")
		await get_tree().create_timer(stat_anim_time).timeout
		stat_anim_controller.stop()
		var new_report = KnowledgeRecord.new()
		new_report.create_normal_record(selectedKnowl, needed_num, got_num ,get_proficiency(selectedKnowl))
		playerData.knowl_history.append(new_report)
		print("MOD: %s. GOT: %s. NEED: %s. PROF: %s (%s). FINAL: %s" % [add_mod, d20_throw, needed_num, get_proficiency(selectedKnowl), selectedKnowl.get_proficiency_string(), got_num])
		update_history.emit()
		stat_t_win.hide()
		# Back to default
		stat_win_anim.hide()
		stat_win_control.show()

func get_proficiency(knowl : Knowledge) -> int:
	var player_proficiency : int = playerData.proficiency_num
	match knowl.proficiencyType:
		Knowledge.PROFICIENCY.PROFICIENCY:
			return player_proficiency
		Knowledge.PROFICIENCY.HALF_PROFICIENCY:
			if player_proficiency - 1 == 0: return 0
			if player_proficiency % 2 == 0:
				return player_proficiency / 2
			elif (player_proficiency - 1) % 2 == 0: 
				return (player_proficiency - 1) / 2
			else:
				return 1
		Knowledge.PROFICIENCY.EXPERTISE:
			return player_proficiency * 2
		_:
			return 0
