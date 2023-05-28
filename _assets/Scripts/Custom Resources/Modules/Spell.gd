extends Resource

## Spell resource with all its data.
class_name Spell

enum TYPES {
	NONE, 
	BASE, 
	ATAQUE,
	DEFENSA,
	UTILIDAD, 
	OTRO
}

@export var spellName : String = "none"

#@export var active : bool = false #if active then show up in spelllist
@export var combat : bool = false

@export_range(0, 20) var level : int = 1
@export var races : Array[Race.RACES]

#@export var classRestriction : Array[]
#@export var classRestriction : CLASS = CLASS.ALL

## Array list with all the spell types.
## To use the strings within use [method getTypesAsString]
@export var spellType : Array[TYPES]
@export var throwMultiplier : String = "1"
@export_enum("d4", "d6", "d8", "d10", "d12", "d20", "none") var throwDice : String = "d4"
@export_range(0, 200) var rangeDistance : int = 0
@export_enum("FUE", "DES", "CON", "INT", "SAB", "CAR", "none") var saveThrow : String = "none"
@export_multiline var description : String

@export_category("Elemental")
@export var isElemental : bool = false
@export var element : Element
## Multipliers are strings because they can hold other information in their prefixes such as:
## _ : Take the lowest of the dices thrown
## ' : Take the largest of the dices thrown
## - : Negative number
@export var buffMuliplier : String = "1"
@export_enum("d4", "d6", "d8", "d10", "d12", "d20", "none") var buffElementalDice : String = "d4"
@export var debuffMuliplier : String = "1"
@export_enum("d4", "d6", "d8", "d10", "d12", "d20", "none") var debuffElementalDice : String = "d4"

@export_category("Other")
@export var passive : Passive
@export var infoLink : String

## This returns an Array[String]. 
func getTypesAsString():
	var stringList : Array[String] = []
	for n in spellType.size():
		stringList.append(TYPES.keys()[spellType[n]]) 
	return stringList

## This returns an Array[String]. 
func getRacesAsString():
	var stringList : Array[String] = []
	for n in races.size():
		stringList.append(Race.RACES.keys()[races[n]]) 
	return stringList

func goToLink():
	if (infoLink): OS.shell_open(infoLink)
