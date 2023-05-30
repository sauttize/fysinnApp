extends Window

var playerData : PlayerData = preload("res://_assets/Scripts/Custom Resources/PlayerSave.tres")
@onready var number : SpinBox = $vbox/number
@onready var option : OptionButton = $vbox/options
@onready var okButton : Button = $vbox/ok
@export var fameLabel : Label
@export var criminalLabel : Label

func _ready() -> void:
#	close_requested.connect(hide)
	okButton.button_up.connect(update_number)

func update_number():
	if number.value == null : return
	if option.selected == -1 : return
	
	if option.selected == 0: # Fame
		playerData.famePercentage += float(number.value)
	elif option.selected == 1: # Criminality
		playerData.criminalPercentage += float(number.value)
	update_labels()
	hide()

func update_labels():
	if !(fameLabel && criminalLabel): return
	fameLabel.text = str(playerData.famePercentage)
	criminalLabel.text = str(playerData.criminalPercentage)
