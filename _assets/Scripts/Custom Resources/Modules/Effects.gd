extends Resource
class_name Effect

@export var effectName : String = "title"
@export_enum("Fijo", "Temporal", "Activable") var effectType : String = "Temporal"
@export_multiline var effectDescription : String = "-"
@export var time_hs : float = 0.0
@export var uses : int = 0
@export var functionName : StringName = "-"
@export var isActivable : bool = false
@export var isRemovable : bool = true
#@export_file var scriptDir : String
var effectAction : Callable = Callable(self, functionName)
@export_category("Kind and Color")
@export_enum("Bad", "Good", "Neutral") var effectNature : String = "Good"
@export_group("Color List")
@export var goodColor : Color = Color("#00a471", 0.4)
@export var badColor : Color = Color("#bc007d", 0.4)
@export var neutralColor : Color = Color("#525252", 0.4)


func getColor() -> Color:
	match effectNature:
		"Good":
			return goodColor
		"Bad":
			return badColor
		"Neutral":
			return neutralColor
		_:
			return Color.BLACK
