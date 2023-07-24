extends Control

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@export var editWindow : Window
@export var editWindowButton : Button

# NodeList
@export_category("Spell List")
@export var spellNodeList : Array[SpellSlot]

func _ready() -> void:
	editWindowButton.button_up.connect(showWindow)
	editWindow.close_requested.connect(update_slots)
	
	update_slots()
	
func showWindow():
	editWindow.popup_centered_clamped()

func update_slots():
	clear_slots()
	for n in playerData.activeSpells.size():
		spellNodeList[n].update_Basics(playerData.activeSpells[n])

func clear_slots():
	for slot in spellNodeList:
		slot.update_Basics(null)
