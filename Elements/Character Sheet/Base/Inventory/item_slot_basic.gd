extends Panel
class_name ItemSlotBasic

@onready var item_name : Label = $elementos/itemName
@onready var item_weight : Label = $elementos/itemWeight

func update_labels(_name : String, weight : float) -> void:
	item_name.text = _name
	item_weight.text = str(weight)
