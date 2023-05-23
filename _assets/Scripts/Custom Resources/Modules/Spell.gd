extends Resource

class_name Spell 

enum TYPE {
	NONE,
	BASE,
	ATTACK,
	DEFENSE,
	UTILITY,
	TERRAIN,
	OTHER
}

enum CLASS {
	ALL
}

enum DICE {
	NONE,
	D6,
	D8,
	D12,
	D20
}

@export var active : bool = false
@export var activable : bool = false

@export var spellName : String = "none"


@export var level : int = 1

@export_flags("None", "All", "", "") var classRestriction
#@export var classRestriction : CLASS = CLASS.ALL

@export_subgroup("Type")
@export_flags("None", "Base", "Attack", "Defense", "Utility", "Terrain", "Other") var spellType
# @export var spellType : TYPE = TYPE.NONE

@export_category("Elemental")
@export var boostElemental : DICE = DICE.NONE
@export var boostLower : bool = false
@export var nerfElemental : DICE = DICE.NONE
@export var nerfGreater : bool = false

@export var passive : Passive


