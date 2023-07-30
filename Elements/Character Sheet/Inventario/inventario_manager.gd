extends MarginContainer

@export var inventory_tab : Panel
@export var armor_tab: Panel
@export var inventory_bttn : Button
@export var armor_bttn : Button

func _ready() -> void:
	inventory_bttn.pressed.connect(change_tab.bind(0))
	armor_bttn.pressed.connect(change_tab.bind(1))

func change_tab(index : int):
	match index:
		0:
			armor_tab.hide()
			inventory_tab.show()
		1:
			inventory_tab.hide()
			armor_tab.show()
