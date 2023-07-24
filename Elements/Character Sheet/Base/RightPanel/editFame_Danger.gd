extends Window

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@onready var number : SpinBox = $vbox/number
@onready var option : OptionButton = $vbox/options
@onready var okButton : Button = $vbox/ok
@export var fameLabel : Label
@export var criminalLabel : Label

func _ready() -> void:
#	close_requested.connect(hide)
	okButton.button_up.connect(update_number)

func update_number():
	if number.value == 0 : return
	if option.selected == -1 : return
	
	if option.selected == 0: # Fame
		playerData.famePercentage += int(number.value)
	elif option.selected == 1: # Criminality
		playerData.criminalPercentage += int(number.value)
	update_labels()
	hide()

func update_labels():
	if !(fameLabel && criminalLabel): return
	fameLabel.text = str(playerData.famePercentage)
	criminalLabel.text = str(playerData.criminalPercentage)
