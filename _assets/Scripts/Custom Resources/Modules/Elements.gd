extends Resource

class_name Element

## List of all possible elements
enum ELEMENTS {
	Acido,
	Agua,
	Aire,
	Arena,
	Fuego,
	Hielo,
	Metal,
	Planta,
	Rayo,
	Tierra,
	None,
	Propio ## Implies that it uses the same element as player.
}

@export var element : ELEMENTS = ELEMENTS.None
@export var strength : Array[ELEMENTS] = []
@export var weakness : Array[ELEMENTS] = []

func getString() -> String:
	return ELEMENTS.keys()[element]

func getSrengthString() -> Array[String]:
	var arrayStr : Array[String] = []
	for n in strength.size():
		arrayStr.append(ELEMENTS.keys()[strength[n]]) 
	return arrayStr

func getWeaknessString() -> Array[String]:
	var arrayStr : Array[String] = []
	for n in weakness.size():
		arrayStr.append(ELEMENTS.keys()[weakness[n]]) 
	return arrayStr

