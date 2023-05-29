extends Window

@onready var dataDump : DataFile = preload("res://_assets/Scripts/Custom Resources/Data/CurrentData.tres")
@export_category("Input")
@export var showButton : Button

@onready var timeInput : SpinBox = $"- margin -/- vbox -/- inputs -/number"
@onready var timeOptionsButton : OptionButton = $"- margin -/- vbox -/- inputs -/options"
@onready var didSleepCheckBox : CheckBox = $"- margin -/- vbox -/- sleep check -/CheckBox"
@onready var okButton : Button = $"- margin -/- vbox -/okButton"

var isHours : bool
var didSleep : bool

signal sendNumbers(addNumber : float, type : DataFile.STATUS)

func _ready() -> void:
	showButton.button_up.connect(popup_centered_clamped)
	close_requested.connect(hide)
	
	okButton.button_up.connect(okButton_pressed)

func okButton_pressed():
	if timeOptionsButton.selected == -1: return
	
	var time_passed : float = timeInput.value
	
	# Is it in hours or minutes?
	if timeOptionsButton.selected == 0: isHours = true
	else: isHours = false
	# Did the player slept?
	if didSleepCheckBox.button_pressed : didSleep = true
	else: didSleep = false
	
	var add_Sleep : float = dataDump.get_new_sleep_number(time_passed, isHours, didSleep)
	var add_Thirst : float = dataDump.get_new_thirst_number(time_passed, isHours)
	var add_Hunger : float = dataDump.get_new_hunger_number(time_passed, isHours)
	print("sleep: " + str(add_Sleep))
	print("hunger: " + str(add_Hunger))
	print("thirst: " + str(add_Thirst))
	sendNumbers.emit(add_Sleep, DataFile.STATUS.SLEEP)
	sendNumbers.emit(add_Thirst, DataFile.STATUS.THIRST)
	sendNumbers.emit(add_Hunger, DataFile.STATUS.HUNGER)
	
	hide()
