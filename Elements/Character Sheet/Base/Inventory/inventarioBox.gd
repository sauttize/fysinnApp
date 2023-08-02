extends ScrollContainer

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@export var max_size_label : RichTextLabel
@export_category("Item list")
@export var items_container : VBoxContainer
@export var basic_slot : PackedScene

func _ready() -> void:
	update_all()

func update_all() -> void:
	update_label()
	update_list()

func update_label() -> void:
	max_size_label.clear()
	var available_weight = playerData.get_available_bag_weight()
	max_size_label.append_text("[i]Capacidad disponible: %sKg[/i]" % [str(available_weight)])
	if playerData.capacity_overflow(): max_size_label.push_color(Color.RED)
	else: max_size_label.push_color(Color.WHITE)

func update_list() -> void:
	for slot in items_container.get_children():
		slot.queue_free()
	
	for item in playerData.item_list:
		var new_slot = basic_slot.instantiate() as ItemSlotBasic
		items_container.add_child(new_slot)
		new_slot.update_labels(item.itemName, item.weight)
