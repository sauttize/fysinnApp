extends MarginContainer

@export var inventory_tab : InventoryManager
@export var armor_tab: ArmorManager
@export var spells_tab : Panel
@export var list_spells : ListSpells
@export var inventory_bttn : Button
@export var armor_bttn : Button
@export var spells_bttn : Button

func _ready() -> void:
	inventory_bttn.pressed.connect(change_tab.bind(0))
	armor_bttn.pressed.connect(change_tab.bind(1))
	spells_bttn.pressed.connect(change_tab.bind(2))
	
	visibility_changed.connect(inventory_tab.update_list)
	visibility_changed.connect(armor_tab.update_all)
	visibility_changed.connect(list_spells.update_list)

func change_tab(index : int):
	match index:
		0:
			armor_tab.hide()
			spells_tab.hide()
			inventory_tab.show()
		1:
			inventory_tab.hide()
			spells_tab.hide()
			armor_tab.show()
		2:
			armor_tab.hide()
			inventory_tab.hide()
			spells_tab.show()

