extends Resource
class_name ClassType

enum CLASSES {
	GUERRERO,
	MAGO_DE_SANGRE,
	DOMADOR_DE_BESTIAS,
	AVENTURERO,
	ALQUIMISTA_HERRERO,
	ASESINO,
	CAZARRECOMPENSAS,
	ARQUERO,
	ELEMENTAL,
	ARTISTA,
	none
}

@export var type : CLASSES = CLASSES.none
@export_range(1, 10) var hitPointMultiplier : int = 1
@export var hitPointDice : int = 4 # 4, 8, 10, 12, 20
@export var knowledgeList : Array[Knowledge]
@export var starterPack : Array[Resource] # Items, weapons and equipment
@export var starterEffects : Array[Effect]
@export_category("Visuals")
@export var primaryColor : Color = Color.DIM_GRAY
@export var secundaryColor : Color = Color.BLACK # for text, ie

func getString(capitalize : bool = true, upperCase : bool = false) -> String:
	var str_ : String = ""
	str_ = (CLASSES.keys()[type])
	if capitalize: str_ = str_.capitalize()
	if upperCase: str_ = str_.to_upper()
	return str_
