extends Resource
class_name Item

@export var itemName : String = "--"
@export_multiline var description : String = "..."
@export var image : Texture2D
@export_enum("Consumible", "Especial", "Desconocido", "Tesoro", "Utilidad", "Mágico") var type : String = "Desconocido"
@export var price : float = 0 # Get depending on what currency
@export_subgroup("Consumibles")
@export var isConsumable : bool = false
@export var uses_cant : int = 0
@export var effect : Array[Effect]

