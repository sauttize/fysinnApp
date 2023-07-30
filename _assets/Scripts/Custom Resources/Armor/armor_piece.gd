extends Resource
class_name ArmorPiece

var rarity_color : Dictionary = {"Normal" : Color('#84390db4'), "Bueno" : Color('#48905bb4'), "Excelente" : Color('#2c4f95b4'),
"Epico" : Color('#9d313bb4'), "Legendario" : Color('#b05aefb4')}

@export var name : String = "-"
@export_enum("Cabeza", "Superior", "Guantes", "Inferior", "Pies", "Accesorio") var type : String
@export var icon : Texture2D
@export var base_value : int = 0
@export var is_equipped : bool = false
@export var effect : Effect
@export_category("Rarity")
@export var extra_value : int = 0
@export var is_rarity_known : bool = false
@export_enum("Normal", "Bueno", "Excelente", "Epico", "Legendario") var rarity : String:
	get:
		if is_rarity_known: return rarity
		else: return "Desconocido"
@export var color : Color :
	get:
		if is_rarity_known: return rarity_color[rarity]
		else: return Color('#737373ad')

