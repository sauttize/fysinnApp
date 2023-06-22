extends Resource
class_name DataFile

enum DICES {d4, d8, d10, d12, d20}

# STATUS VALUES
enum STATUS {SLEEP, HUNGER, THIRST}
var HUNGER_HOURS : float = 2.5 ## Hunger taken each hour
var HUNGER_MINUTES : float = 0.04 ## Each minute
# Thirst
var THIRST_HOURS : float = 3.33 ## Thirst taken each hour
var THIRST_MINUTES : float = 0.05 ## Each minute
# Sleep
var SLEEP_HOURS : float = 12.5 ## Each hour you sleep, the amount you get back
var SLEEP_MINUTES : float = 0.2 ## Each minute
# Did not sleep
var NOT_SLEEP_HOURS : float = 6.66 ## Each hour that passed, sleep got taken
var NOT_SLEEP_MINUTES : float = 0.11 ## Each minute

# LISTS
@export_category("Lists")
@export var RACES_LIST : Array[Race]
@export var CLASSES_LIST : Array[ClassType]
@export var ELEMENT_LIST : Array[Element]
@export var EFFECTS_LIST : Array[Effect]
@export var SPELLS_LIST : Array[Spell]

# KNOWLEDGE LIST
@export_category("Knowledge related")
@export var KNOWLEDGE_LIST : Array[Knowledge]
@export_subgroup("Learning curves")
@export var K_CURVE_PRACTICE : Curve
@export var K_CURVE_BOOK : Curve
@export var K_CURVE_ACADEMY : Curve

@export_category("Console")
@export var bgConsoleColor : Color = Color(0, 0, 0, 0.25)

## KNOWLEDGE METHODS
## Gives a copy of the list, not related to the og's
func get_duplicate_list_knowledge() -> Array[Knowledge]:
	var newList : Array[Knowledge] = []
	for knowl in KNOWLEDGE_LIST:
		var copy : Knowledge = knowl.duplicate()
		newList.append(copy)
	return newList

## GET METHODS
## Gets the class type by the string name
func stringToClass(className : String) -> ClassType:
	var classType : ClassType = ClassType.new()

	className = className.to_upper()
	className = className.replacen(" ", "_")
	var enumType = ClassType.CLASSES[className]
	for c in CLASSES_LIST:
		if c.type == enumType: classType = c
	return classType
## Gets the race type by the string name
func stringToRace(raceName : String) -> Race:
	var race : Race = Race.new()
	
	raceName = raceName.capitalize()
	for r in RACES_LIST:
		if raceName == r.name: race = r
	return race
## Gets the element type by the string name
func stringToElement(elementName : String) -> Element:
	var element : Element = Element.new()
	
	elementName = elementName.capitalize()
	for e in ELEMENT_LIST:
		if elementName == e.getString(): element = e
	return element


## STATUS METHODS
## Get the number of time and depending if it's hours or minutes and if the
## user slept or not, returns the corresponding number.
func get_new_sleep_number(time : float, isHours : bool, didSleep : bool) -> float:
	if isHours:
		if didSleep:
			return float(int(time * SLEEP_HOURS))
		else:
			return -float(int(time * NOT_SLEEP_HOURS))
	else:
		if didSleep:
			return float(int(time * SLEEP_MINUTES))
		else:
			return -float(int(time * NOT_SLEEP_MINUTES))
## Returns the corresponding number to add (in order to substract) to the thirst meter
func get_new_thirst_number(time : float, isHours : bool) -> float:
	if isHours:
		return -float(int(time * THIRST_HOURS))
	else:
		return -float(int(time * THIRST_MINUTES))
## Returns the corresponding number to add (in order to substract) to the hunger meter
func get_new_hunger_number(time : float, isHours : bool) -> float:
	if isHours:
		return -float(int(time * HUNGER_HOURS))
	else:
		return -float(int(time * HUNGER_MINUTES))
