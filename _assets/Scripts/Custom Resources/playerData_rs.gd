extends Resource
class_name PlayerData

# Variables
#BASIC
@export_category("-- Basic --")
@export var nombre : String = "name"
@export var nivel : int = 1
@export var exp : int = 0
@export_enum("Humano", "Draconite", "Naiad", "Raincaster", "Duneborn", "None") 
var raza : String = "None"
@export var elemento : Element
@export var imagen : ImageTexture

#BASE
@export_category("-- Base --")
@export var currentLife : int = 0
@export var maxLife : int = 0
@export_subgroup("Skills")
@export var skills : Array[int] = [0, 0, 0, 0, 0, 0]
@export_subgroup("Modifiers")
@export var modifiers : Array[int] = [0, 0, 0, 0, 0, 0]

#METERS
@export_category("-- Meters --")
@export_range(0, 100) var sleepMeter : int = 100
@export var hungerMeter : int = 100
@export var thirstMeter : int = 100

#FAME AND CRIME
@export_category("-- Fame & Crime --")
@export_range(1, 100) var criminalPercentage : int = 0
@export_range(1, 100) var famePercentage : int = 0

#SPELLS


func updateExp(newExp : int):
	exp += newExp
	
func updateName(newName : String):
	nombre = newName
	
