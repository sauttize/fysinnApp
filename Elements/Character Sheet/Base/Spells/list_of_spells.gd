extends MarginContainer

@onready var playerData : PlayerData = preload("res://_assets/Scripts/Custom Resources/PlayerSave.tres")
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

@export_category("Other")
@export var racesOrdered : Array[Race] # raincaster, naiad, duneborn, humano, draconite
@export_subgroup("Combat list")
@export var isCombatList : bool = false
@onready var availableLabel : Label = $container/top/Disponibles

func _ready() -> void:
	if !isCombatList: availableLabel.hide()
	
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
		print("1 " + str(fromLevel) + " " + str(toLevel))
		clear_cache_temporary()
		for spell in tempCache:
			if spell.level > fromLevel && spell.level < toLevel:
				spellsCache.push_back(spell)
	
	if !(byRace == allRaces):
		print("2")
		clear_cache_temporary()
		for spell in tempCache:
			for race in byRace:
				if spell.races.has(race):
					spellsCache.push_back(spell)

func clear_cache_temporary():
	print(spellsCache)
	tempCache.clear()
	tempCache = spellsCache.duplicate()
	spellsCache.clear()
	print(tempCache)

func get_level_vector() -> Vector2:
	var retVector : Vector2
	
	retVector.x = minLevel_value.value
	retVector.y = maxLevel_value.value
	
	return retVector

func get_races_array() -> Array[Race]:
	var retArray : Array[Race]
	
	if raincaster_ch.button_pressed: retArray.push_back(racesOrdered[0])
	if naiad_ch.button_pressed: retArray.push_back(racesOrdered[1])
	if duneborn_ch.button_pressed: retArray.push_back(racesOrdered[2])
	if humano_ch.button_pressed: retArray.push_back(racesOrdered[3])
	if draconite_ch.button_pressed: retArray.push_back(racesOrdered[4])
	
	if retArray.size() <= 0: return allRaces
	else: return retArray
