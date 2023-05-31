extends Resource
class_name DataFile

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

# KNOWLEDGE LIST
const KNOWLEDGE_LIST : Array[String] = []
@export_category("Learning curves")
@export var K_CURVE_PRACTICE : Curve
@export var K_CURVE_BOOK : Curve
@export var K_CURVE_ACADEMY : Curve

# STATUS METHODS
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
