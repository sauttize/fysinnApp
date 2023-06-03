extends Resource
class_name PlayerData

# Variables
#BASIC
@export_category("-- Basic --")
@export var nombre : String = "name"
@export var nivel : int = 1
@export var exp : int = 0
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
@export_subgroup("Skills")
@export var stats : Stats

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

#KNOWLEDGE RELATED
@export_category("-- Knowledge --")
@export var myKnowledgeList : Array[Knowledge]

#OTHER
@export_category("Other")
@export var lastSaved : String

func updateExp(newExp : int):
	exp += newExp
	
func updateName(newName : String):
	nombre = newName
	
func newSave():
	lastSaved = Time.get_datetime_string_from_system()
