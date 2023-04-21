extends Resource
class_name PlayerData

# Variables
#BASIC
@export var nombre : String = "name"
@export var nivel : int = 1
@export var exp : int = 0
@export_enum("humano", "draconite", "naiad", "raincaster", "duneborn", "none") 
var raza : String = "none"
@export var imagen : ImageTexture

#BASE
@export var skills : Array[int] = [0, 0, 0, 0, 0, 0]
@export var modifiers : Array[int] = [0, 0, 0, 0, 0, 0]
@export var currentLife : int = 0
@export var maxLife : int = 0


func updateExp(newExp : int):
	exp += newExp
	
func updateName(newName : String):
	nombre = newName
	

