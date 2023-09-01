extends Resource
class_name Knowledge

enum PROFICIENCY {NONE, PROFICIENCY, HALF_PROFICIENCY, EXPERTISE}

@export var knowledgeName : String = "none"
@export_multiline var description : String
@export var currentPercentage : float = 0:
	get:  
		var per = (maxPercentage - minPercentage) * (float(currentLevel - 1) / 10)
		var res = minPercentage + per
		if currentLevel == 1: res = minPercentage
		elif currentLevel == 10: res = maxPercentage
		return clamp(res, minPercentage, maxPercentage)
	set(num):
		currentPercentage = clamp(num, minPercentage, maxPercentage)
@export var temporaryPercentage : float = 0 : ## For learning
	get:
		return fail_per_add * failAttempts
@export var fail_per_add : float = 0.002 ## Each fail adds this percentage
@export var currentLevel : int = 1:
	set(num):
		currentLevel = clamp(num, 1, 10)
@export var minPercentage : float = 1
@export var maxPercentage : float = 100
@export var temporary_add : float = 0 ## Just for throws
@export var failAttempts : int = 0
@export_subgroup("Motivation")
@export var motivation : int = 0 :
	get: return clamp(motivation, 0, max_motivation)
@export var max_motivation : int = 30
@export var fail_lose : int = 2 ## Amount of motivation lose when failing throw
@export_category("Others")
## How many continuous throws can the player make.
@export_range(1, 20) var max_throw_num : int = 1
@export var proficiencyType : PROFICIENCY = PROFICIENCY.NONE
## None means this knowledge has no stat associated.
@export var associatedStat : Stats.STATS
@export var associatedClasses : Array[ClassType]
@export var associatedEffects : Array[Effect]

func get_proficiency_string():
	return PROFICIENCY.keys()[proficiencyType]

func return_by_name(knowlName : String):
	if knowlName == knowledgeName:
		return self
	else: return null

## Knowledge throw uses the knowledge current percentage as a posibility for success or failure.
func special_throw(mod_motivation : bool = true) -> bool:
	var percentage := currentPercentage + temporary_add
	percentage /= 100
	var rand_num := randf_range(0, 1)
	
	if rand_num < percentage: return true
	else: 
		if mod_motivation: motivation -= fail_lose
		return false

# func learn (gets percentage of success from code)
# func learn by book (pass dataDump) could be all in one.
# func learn by practice (pass dataDump)
# func learn by academy (pass dataDump)
