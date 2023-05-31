extends Resource
class_name Stats

enum STATS {FUE, DES, CON, INT, SAB, CAR}

#Abilty Score
@export_subgroup("Ability Scores")
@export_range(1,30) var strength : int = 0
@export_range(1,30) var dexterity : int = 0
@export_range(1,30) var constitution : int = 0
@export_range(1,30) var intelligence : int = 0
@export_range(1,30) var wisdom : int = 0
@export_range(1,30) var charisma : int = 0

#Modifiers
@export_subgroup("Modifiers")
@export_range(-5,10) var strengthMOD : int = 0
@export_range(-5,10) var dexterityMOD : int = 0
@export_range(-5,10) var constitutionMOD : int = 0
@export_range(-5,10) var intelligenceMOD : int = 0
@export_range(-5,10) var wisdomMOD : int = 0
@export_range(-5,10) var charismaMOD : int = 0

func stat_to_mod(ability : int):
	match ability:
		1:
			return (-5)
		2, 3:
			return (-4)
		4,5:
			return (-3)
		6,7:
			return (-2)
		8,9:
			return (-1)
		10,11:
			return 0
		12,13:
			return 1
		14,15:
			return 2
		16,17:
			return 3
		18, 19:
			return 4
		20, 21:
			return 5
		22,23:
			return 6
		24,25:
			return 7
		26,27:
			return 8
		28,29:
			return 9
		30:
			return 10
		_:
			return 0
