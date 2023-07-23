extends Window

# BUTTONS
@onready var activeTab : Button = $Elements/Botones/Activos
@onready var learnedTab : Button = $Elements/Botones/Aprendidos
@onready var tabManager : TabContainer = $Elements/TabContainer

func _ready() -> void:
	close_requested.connect(hide)
	
	activeTab.button_up.connect(switchToActiveTab)
	learnedTab.button_up.connect(switchToLearnedTab)

func switchToActiveTab():
	tabManager.current_tab = 0
func switchToLearnedTab():
	tabManager.current_tab = 1

