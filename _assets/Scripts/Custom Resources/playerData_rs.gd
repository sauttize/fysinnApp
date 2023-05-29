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
@export var actionPoints : int = 4
@export var velocity : int = 30
@export var initiativeNum : int = 1
@export_subgroup("Skills")
@export var stats : Stats

#METERS
@export_category("-- Meters --")
@export_range(0, 100) var sleepMeter : float = 100
@export var hungerMeter : float = 100
@export var thirstMeter : float = 100

#FAME AND CRIME
@export_category("-- Fame & Crime --")
@export_range(1, 100) var criminalPercentage : int = 0
@export_range(1, 100) var famePercentage : int = 0

#SPELLS
@export_category("Spells")
@export_subgroup("All")
@export var spells : Array[Spell]
@export_subgroup("Active")
@export var activeSpells : Array[Spell]

func updateExp(newExp : int):
	exp += newExp
	
func updateName(newName : String):
	nombre = newName
	
