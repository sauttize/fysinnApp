extends Control

@export_category("Dependencies")
@export var editLifeWindow : Window
@export var statsNode : Control
@export var currentLifeLabel : Label
@export var maxLifeLabel : Label
var currentLife : int
var maxLife : int

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

func _ready() -> void:
	updateMaxLife()
	updateCurrentLife()
	compare_current_with_max()
	
	#Window signals
	editLifeWindow.addCurrent.connect(add_lifepoints)
	editLifeWindow.subCurrent.connect(sub_lifepoints)
	editLifeWindow.updateMax.connect(add_maxlife)
	
	#Updates maxLife when modifier changes
	statsNode.updateMaxLife.connect(mod_changes)

# Current Life
func updateCurrentLife():
	currentLifeLabel.text = str(playerData.currentLife)
	currentLife = playerData.currentLife

func add_lifepoints(value : int):
	currentLife += value
	compare_current_with_max()
	
func sub_lifepoints(value : int):
	currentLife -= value
	compare_current_with_max()

func compare_current_with_max():
	if (currentLife > maxLife):
		currentLife = maxLife
	playerData.currentLife = currentLife
	updateCurrentLife()

# Max Life
func mod_changes():
	compare_current_with_max()
	updateMaxLife()

func updateMaxLife():
	maxLife = playerData.maxLife + playerData.stats.constitutionMOD
	maxLifeLabel.text = str(maxLife)

func add_maxlife(value : int):
	playerData.maxLife += value 
	updateMaxLife()

	
