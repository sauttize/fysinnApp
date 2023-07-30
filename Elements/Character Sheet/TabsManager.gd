extends TabContainer

@export_category("Tabs")
@export var baseButton : Button
@export var conocimientosButton : Button
@export var inventarioButton : Button
@export var relacionesButton : Button
@export var notasButton : Button
@export var consoleButton : Button

func _ready() -> void:
	baseButton.pressed.connect(changeTab.bind(0))
	conocimientosButton.pressed.connect(changeTab.bind(1))
	inventarioButton.pressed.connect(changeTab.bind(3))
#	relacionesButton.pressed.connect(changeTab.bind(4))
#	notasButton.pressed.connect(changeTab.bind(5))
	consoleButton.pressed.connect(changeTab.bind(2))

func changeTab (tab_num : int):
	set_current_tab(tab_num)
