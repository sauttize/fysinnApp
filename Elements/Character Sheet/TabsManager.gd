extends TabContainer

@export_category("Tabs")
@export var baseButton : Button
@export var conocimientosButton : Button
@export var mascotasButton : Button
@export var relacionesButton : Button
@export var notasButton : Button
@export var consoleButton : Button

func _ready() -> void:
	baseButton.button_up.connect(changeTab.bind(0))
	conocimientosButton.button_up.connect(changeTab.bind(1))
#	mascotasButton.button_up.connect(changeTab(2))
#	relacionesButton.button_up.connect(changeTab(3))
#	notasButton.button_up.connect(changeTab(4))
	consoleButton.button_up.connect(changeTab.bind(2))

func changeTab (tab_num : int):
	set_current_tab(tab_num)
