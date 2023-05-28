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
@export_category("Visuals")
@export var primaryColor : Color = Color.DIM_GRAY
@export var secundaryColor : Color = Color.BLACK # for text, ie

func getString() -> String:
	return CLASSES.keys()[type]
