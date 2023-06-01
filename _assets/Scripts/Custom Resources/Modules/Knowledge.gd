extends Resource
class_name Knowledge

enum PROFICIENCY {NONE, PROFICIENCY, HALF_PROFICIENCY, EXPERTISE}

@export var knowledgeName : String = "none"
@export var currentPercentage : float = 0:
	set(num):
		currentPercentage = clamp(num, minPercentage, maxPercentage)
@export var currentLevel : int = 1:
	set(num):
		currentLevel = clamp(num, 1, 10)
@export var minPercentage : float = 1
@export var maxPercentage : float = 100
@export var failAttempts : int = 0
@export var motivation : int = 0
@export var proficiencyType : PROFICIENCY = PROFICIENCY.NONE
@export var associatedStat : Stats.STATS
@export var associatedClasses : Array[ClassType]
@export var associatedEffects : Array[Effect]

func get_proficiency_string():
	return PROFICIENCY.keys()[proficiencyType]

# func learn (gets percentage of success from code)
# func learn by book (pass dataDump) could be all in one.
# func learn by practice (pass dataDump)
# func learn by academy (pass dataDump)
