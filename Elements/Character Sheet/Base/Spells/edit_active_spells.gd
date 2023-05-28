extends Window

@export var playerData : PlayerData = preload("res://_assets/Scripts/Custom Resources/PlayerSave.tres")

# BUTTONS
@onready var activeTab : Button = $Elements/Botones/Activos
@onready var learnedTab : Button = $Elements/Botones/Aprendidos
@onready var tabManager : TabContainer = $Elements/TabContainer

# LEARNED TAB
@onready var learnedList : ItemList = $Elements/TabContainer/Aprendidos/bg/margin/container/playerList


func _ready() -> void:
	close_requested.connect(hide)
	
	activeTab.button_up.connect(switchToActiveTab)
	learnedTab.button_up.connect(switchToLearnedTab)
	
	updateLearnedList()

func switchToActiveTab():
	tabManager.current_tab = 0
	
func switchToLearnedTab():
	tabManager.current_tab = 1

# Learned tab

func updateLearnedList():
	learnedList.clear()
	for spell in playerData.spells:
		if spell.combat: 
			learnedList.add_item(spell.spellName, null ,true)
