extends MarginContainer

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@onready var learnedList : ItemList = $container/playerList
var spellsCache : Array[Spell]
var tempCache : Array[Spell]

# VARIABLES
@export_category("Filters")
@export var showAll : bool = false
var allRaces : Array[Race] = [GameManager.GetRaceNone()]


@export_subgroup("Nodes")
@onready var filterButton : Button = $container/top/filtrar
@onready var filterWindow : Window = $Filters

@onready var showAll_ch : CheckBox = $Filters/Margin/Elements/ShowAll

@onready var minLevel_value : SpinBox = $Filters/Margin/Elements/Level/Options/Min/SpinBox
@onready var maxLevel_value : SpinBox = $Filters/Margin/Elements/Level/Options/Max/SpinBox

@onready var raincaster_ch : CheckBox = $Filters/Margin/Elements/Race/List/Raincaster
@onready var naiad_ch : CheckBox = $Filters/Margin/Elements/Race/List/Naiad
@onready var duneborn_ch : CheckBox = $Filters/Margin/Elements/Race/List/Duneborn
@onready var humano_ch : CheckBox = $Filters/Margin/Elements/Race/List/Humano
@onready var draconite_ch : CheckBox = $Filters/Margin/Elements/Race/List/Draconite

@onready var applyFilter_button : Button = $Filters/Margin/Elements/FilterButton

@export_subgroup("Information")
@export var spellInfoButton : Button
@export var spellInfoWindow : PackedScene

@export_category("Other")
@export var racesOrdered : Array[Race] # raincaster, naiad, duneborn, humano, draconite
@export_subgroup("Combat list")
@export var isCombatList : bool = false
@onready var availableLabel : Label = $container/top/Disponibles
@onready var activateButton : Button = $container/activateSelected

func _ready() -> void:
	if !isCombatList: 
		availableLabel.hide()
		activateButton.hide()
	
	activateButton.pressed.connect(activate_spell)
	spellInfoButton.pressed.connect(show_information)
	
	filter_list()
	show_by_cache()
	
	filterWindow.close_requested.connect(filterWindow.hide)
	
	filterButton.pressed.connect(filterWindow.show)
	applyFilter_button.pressed.connect(apply_filter)

func show_by_cache():
	learnedList.clear()
	for spell in spellsCache:
		if isCombatList && spell.combat: 
			learnedList.add_item(spell.spellName, null ,true)
		elif !isCombatList:
			learnedList.add_item(spell.spellName, null ,true)

func apply_filter():
	var min_max_level = get_level_vector()
	var racesFilter = get_races_array()
	
	showAll = showAll_ch.button_pressed
	filter_list(min_max_level.x, min_max_level.y, racesFilter)
	
	show_by_cache()
	
	filterWindow.hide()

func filter_list(fromLevel:int = 1, toLevel:int = 20, byRace:Array[Race] = allRaces):
	spellsCache.clear()
	if showAll: spellsCache = GameManager.GetAllSpells()
	else: spellsCache = playerData.spells
	
	if !((fromLevel == 1) && (toLevel == 20)) && fromLevel < toLevel:
		clear_cache_temporary()
		for spell in tempCache:
			if spell.level > fromLevel && spell.level < toLevel:
				spellsCache.push_back(spell)
	
	if !(byRace == allRaces):
		clear_cache_temporary()
		for spell in tempCache:
			for race in byRace:
				if spell.races.has(race):
					spellsCache.push_back(spell)

func activate_spell():
	if playerData.activeSpells.size() == 4:
		Utilities.create_PopUp("Ya tienes 4 hechizos activos.")
		return
	if learnedList.item_count == 0 || get_current_index() == -1:
		Utilities.create_PopUp("No has seleccionado ningun hechizo...")
		return
	if learnedList.item_count > 0:
		var selectedIndex : int = learnedList.get_selected_items()[0]
		var selectedSpellName : String = learnedList.get_item_text(selectedIndex)
		for spell in spellsCache:
			if spell.spellName == selectedSpellName :
				playerData.activeSpells.append(spell)
				Utilities.create_PopUp("¡%s fue añadido!" % [spell.spellName])

func get_current_index() -> int:
	if learnedList.item_count <= 0 || !learnedList.is_anything_selected(): return -1
	var selectedIndex : int = learnedList.get_selected_items()[0]
	return selectedIndex

func clear_cache_temporary():
	tempCache.clear()
	tempCache = spellsCache.duplicate()
	spellsCache.clear()

func get_level_vector() -> Vector2:
	var retVector : Vector2
	
	retVector.x = minLevel_value.value
	retVector.y = maxLevel_value.value
	
	return retVector

func get_races_array() -> Array[Race]:
	var retArray : Array[Race] = []
	
	if raincaster_ch.button_pressed: retArray.push_back(racesOrdered[0])
	if naiad_ch.button_pressed: retArray.push_back(racesOrdered[1])
	if duneborn_ch.button_pressed: retArray.push_back(racesOrdered[2])
	if humano_ch.button_pressed: retArray.push_back(racesOrdered[3])
	if draconite_ch.button_pressed: retArray.push_back(racesOrdered[4])
	
	if retArray.size() <= 0: return allRaces
	else: return retArray

func show_information():
	var index : int = get_current_index()
	if index == -1:
		Utilities.create_PopUp("No has seleccionado ningun hechizo...")
		return
	var about : Spell = spellsCache[index]
	var window = spellInfoWindow.instantiate() as SpellInfoWindow
	window.update_Complete(about)
	window.close_requested.connect(window.queue_free)
	add_child(window)
	window.show()
