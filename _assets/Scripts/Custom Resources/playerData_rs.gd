extends Resource
class_name PlayerData

# Variables
#BASIC
@export_category("-- Basic --")
@export var nombre : String = "name"
@export var nivel : int = 1
@export var experiencia : int = 0
@export var raza : Race
@export var classtype : ClassType
@export var elemento : Element
@export var imagen : ImageTexture

#BASE
@export_category("-- Base --")
@export var currentLife : int = 0
@export var maxLife : int = 0
var casillasMov : int = 0:
	get:
		return int(speed / 5)
@export var speed : int = 30
@export var initiativeNum : int = 1:
	set(num): initiativeNum = clamp(num, 1, 5)
@export var proficiency_num : int = 1 :
	get:
		return clamp(proficiency_num, 1, 100)
@export_subgroup("Skills")
@export var stats : Stats = Stats.new()
@export var goodStrike : int = 0
@export var badStrike : int = 0

#MONEY AND INVENTORY
@export_category("-- Money / Inventory --")
@export_subgroup("Money")
@export var pc : int = 0
@export var pp : int = 0
@export var pe : int = 0
@export var po : int = 0
@export var ppt : int = 0
@export_subgroup("Inventory")
@export var max_bag_weight : float = 0 # In kg
@export var current_weight : float :
	get:
		if item_list.size() == 0: return 0
		else:
			var cont : float = 0
			for item in item_list:
				cont += item.weight
			return cont
@export var item_list : Array[Item] = []
@export_subgroup("Armor")
@export var body_type : int = 0
@export var armor_pieces : Array[ArmorPiece] = []
@export var armor_equipped : ArmorSet

#METERS
@export_category("-- Meters --")
@export var sleepMeter : float = 100:
	set(num): sleepMeter = clamp(num, -10, 100)
@export var hungerMeter : float = 100:
	set(num): hungerMeter = clamp(num, -10, 100)
@export var thirstMeter : float = 100:
	set(num): thirstMeter = clamp(num, -10, 100)

#FAME AND CRIME
@export_category("-- Fame & Crime --")
@export var criminalPercentage : int = 0:
	set(num): criminalPercentage = clamp(num, 0, 100)
@export var famePercentage : int = 0:
	set(num): famePercentage = clamp(num, 0, 100)

#SPELLS
@export_category("-- Spells --")
@export_subgroup("All")
@export var spells : Array[Spell]
@export_subgroup("Active")
@export var activeSpells : Array[Spell]

#EFFECTS
@export_category("-- Effects --")
@export var activeEffects : Array[Effect]

#KNOWLEDGE RELATED
@export_category("-- Knowledge --")
@export var myKnowledgeList : Array[Knowledge]
@export var knowl_history : Array[KnowledgeRecord]

#ROL RELATED
@export_category("-- Rol related --")
@export var relationships : Array[Relationship]

#OTHER
@export_category("-- Other --")
@export var lastSaved : Dictionary
@export var PATH : String = ""
@export var UNIQUE_ID : int = -1
@export var console_color : Color
@export var customization : Customization

## Functions

func updateExp(newExp : int):
	experiencia += newExp
	
func newSave():
	lastSaved = Time.get_datetime_dict_from_system()

func last_save_hour() -> String:
	return str(lastSaved['hour']) + ":" + str(lastSaved["minute"]) + ":" + str(lastSaved["second"])

func last_save_date() -> String:
	return str(lastSaved['day']) + "/" + str(lastSaved['month']) + "/" + str(lastSaved['year'])

func generate_id(compareWith : Array[PlayerData]):
	var cantBe : Array[int] = []
	for data in compareWith:
		cantBe.push_back(data.UNIQUE_ID)
	if UNIQUE_ID != -1:
		var number = RandomNumberGenerator.new().randi_range(1, 1000000)
		UNIQUE_ID = number
		
# Knowledge
func new_knowledge_list(from : DataFile):
	myKnowledgeList = from.get_duplicate_list_knowledge()

func max_motivation() -> void:
	for knowl in myKnowledgeList:
		knowl.motivation = knowl.max_motivation

## Inventory
func get_available_bag_weight() -> float:
	return max_bag_weight - current_weight
func capacity_overflow() -> bool:
	if current_weight > max_bag_weight:
		return true
	else: return false
