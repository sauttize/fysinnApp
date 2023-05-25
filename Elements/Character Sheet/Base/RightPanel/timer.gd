extends Label

enum StatusTimers {HUNGER, SLEEP, THIRST} 

# CONSTANTS
const NEW_DAY_HUNGER = (-20)
const NEW_DAY_SLEEP = 80
const NEW_DAY_THIRST = (-20)

# Change currentNum to a save 
@export_category("Dependencies")
@export var timer : Timer 
@export var activateButton : Button
@export var newDayButton : Button
@export_category("Variables")
@export var statusType : StatusTimers
@export var currentNum : int = 100
@export var minutesUntilZero : int = 20
@export var activated : bool = false
var waitSeconds : float = 20

@export_category("Color")
# Color check (in %)
const ORANGE = 0.50
const RED = 0.25
var orangeValue : float = 50
var redValue : float = 25

# Colors itself
@export var orangeColor : Color = Color("#fcc82b")
@export var redColor : Color = Color("#b70200")
@export var desactivatedTimerColor : Color = Color("#181818")


func _ready() -> void:
	update_data()
	timer.timeout.connect(on_timeout_reached)
	activateButton.button_up.connect(on_activate_button_pressed)
	newDayButton.button_up.connect(on_newDay_button_pressed)

func update_data():
	# Sets data
	text = str(currentNum)
	var SecFromMin = minutesUntilZero * 60
	redValue = currentNum * RED
	orangeValue = currentNum * ORANGE
	
	#This is the seconds until a change in number
	waitSeconds = SecFromMin / float(currentNum)
	timer.wait_time = waitSeconds
	
	# Mostly for debuging. Should only start by button.
	if activated: timer_runnning()
	else: timer_stopped()

func substraction():
	currentNum -= 1

func update_number():
	text = str(currentNum)
	
	if currentNum < orangeValue && currentNum > redValue:
		add_theme_color_override("font_color", orangeColor)
	elif currentNum < redValue:
		add_theme_color_override("font_color", redColor)
	
func timer_stopped():
	add_theme_color_override("font_color", desactivatedTimerColor)
	timer.stop()

func timer_runnning():
	add_theme_color_override("font_color", Color.WHITE)
	timer.start()

# Signals from other nodes
# Timer
func on_timeout_reached():
	if activated:
		substraction()
		update_number()
# Buttons
# Activate Button
func on_activate_button_pressed():
	if activated: 
		activated = false
		timer_stopped()
	else: 
		activated = true
		timer_runnning()
# New day Button
func on_newDay_button_pressed():
	match statusType:
		StatusTimers.HUNGER:
			currentNum += NEW_DAY_HUNGER
			update_number()
		StatusTimers.SLEEP:
			currentNum += NEW_DAY_SLEEP
			if currentNum > 100: currentNum = 100
			update_number()
		StatusTimers.THIRST:
			currentNum += NEW_DAY_THIRST
			update_number()
