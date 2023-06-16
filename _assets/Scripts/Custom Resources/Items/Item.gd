extends Resource
class_name Item

@export var itemName : String = "--"
@export_multiline var description : String = "..."
@export var price : float = 0 # Get depending on what currency
@export var isConsumable : bool = false
@export var effect : Array[Effect]

