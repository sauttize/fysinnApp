extends Control

@export_category("Dependencies")
@export var editLifeWindow : Window
@export var statsNode : Control
@export var currentLifeLabel : Label
@export var maxLifeLabel : Label
var currentLife : int
var maxLife : int

@export var _playerData : PlayerData

func _ready() -> void:
	_playerData = GameManager.get_file(_playerData)
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
	currentLifeLabel.text = str(_playerData.currentLife)
	currentLife = _playerData.currentLife

func add_lifepoints(value : int):
	currentLife += value
	compare_current_with_max()
	
func sub_lifepoints(value : int):
	currentLife -= value
	compare_current_with_max()

func compare_current_with_max():
	if (currentLife > maxLife):
		currentLife = maxLife
	_playerData.currentLife = currentLife
	updateCurrentLife()

# Max Life
func mod_changes():
	compare_current_with_max()
	updateMaxLife()

func updateMaxLife():
	maxLife = _playerData.maxLife + _playerData.stats.constitutionMOD
	maxLifeLabel.text = str(maxLife)

func add_maxlife(value : int):
	_playerData.maxLife += value 
	updateMaxLife()

	
