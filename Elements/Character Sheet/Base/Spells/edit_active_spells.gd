extends Window

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

# BUTTONS
@onready var activeTab : Button = $Elements/Botones/Activos
@onready var learnedTab : Button = $Elements/Botones/Aprendidos
@onready var tabManager : TabContainer = $Elements/TabContainer

# ACTIVE SPELLS MANAGER
@export_category("Spell slots")
@export var listOfSlots : Array[SpellSlot]
@export var deleteSpellButtons : Array[Button]

func _ready() -> void:
	close_requested.connect(hide)
	
	activeTab.button_up.connect(switchToActiveTab)
	learnedTab.button_up.connect(switchToLearnedTab)
	
	update_slots()
	
	for n in deleteSpellButtons.size():
		deleteSpellButtons[n].pressed.connect(delete_spell.bind(n))

func switchToActiveTab():
	tabManager.current_tab = 0
	update_slots()

func update_slots():
	clean_slots()
	for n in playerData.activeSpells.size():
		listOfSlots[n].update_Basics(playerData.activeSpells[n])

func clean_slots():
	for slot in listOfSlots:
		slot.update_Basics(null)

func delete_spell(index : int):
	if (index + 1) > playerData.activeSpells.size():
		Utilities.create_PopUp("Slot vacio, no hay nada que eliminar.")
		return
	playerData.activeSpells.pop_at(index)
	update_slots()

func switchToLearnedTab():
	tabManager.current_tab = 1

