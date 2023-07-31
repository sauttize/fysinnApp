extends Panel

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

var current_item : Item = null
@export var item_list : ItemList
@export_subgroup("Item information")
@export var item_photo : TextureRect
@export var item_data : RichTextLabel
@export var price_num : SpinBox

func _ready() -> void:
	update_list()
	item_list.item_selected.connect(get_item_info)

func update_list() -> void:
	item_list.clear()
	for item in playerData.item_list:
		item_list.add_item(item.itemName)

func get_item_info() -> void:
	if current_item:
		if current_item.image: item_photo.texture = current_item.image
		item_data.clear()
		item_data.append_text("[b]Nombre:[/b] %s" % [current_item.itemName])
		item_data.append_text("[b]Tipo[/b]: %s" % [current_item.type])
		if current_item.isConsumable: item_data.append_text("[b]Usos[/b]: %s" % [str(current_item.uses_cant)])
		item_data.append_text("[b]Descripcion:[/b] %s" % [current_item.description])
