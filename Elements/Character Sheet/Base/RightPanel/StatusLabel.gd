extends Label

var dataDump : DataFile = preload("res://_assets/Scripts/Custom Resources/Data/CurrentData.tres")
var playerData : PlayerData = preload("res://_assets/Scripts/Custom Resources/PlayerSave.tres")

@export var type : DataFile.STATUS
@onready var editWindow : Window = $"../../../../../stats/vbox/EditStatus"
@export var currentNum : float = 0
@export_category("Color")
# Color check (in %)
const ORANGE : float = 50 # Less than 50%
const RED : float = 25 # Less than 25%

# Colors itself
@export var orangeColor : Color = Color("#fcc82b")
@export var redColor : Color = Color("#b70200")

func _ready() -> void:
	update_num_fromFile()
	update_colors()
	
	editWindow.sendNumbers.connect(update_num)

func update_num(number : float, checkType : DataFile.STATUS):
	if checkType != type: return
	
	currentNum += number
	if currentNum > 100: currentNum = 100
	if currentNum < -10: currentNum = -10
	
	update_colors()
	text = str(currentNum)
	
	match type:
		dataDump.STATUS.SLEEP:
			playerData.sleepMeter = currentNum
		dataDump.STATUS.HUNGER:
			playerData.hungerMeter = currentNum
		dataDump.STATUS.THIRST:
			playerData.thirstMeter = currentNum

func update_num_fromFile():
	if !playerData: return
	match type:
		dataDump.STATUS.SLEEP:
			currentNum = playerData.sleepMeter
		dataDump.STATUS.HUNGER:
			currentNum = playerData.hungerMeter
		dataDump.STATUS.THIRST:
			currentNum = playerData.thirstMeter

func update_colors():
	if currentNum < ORANGE && currentNum > RED:
		add_theme_color_override("font_color", orangeColor)
	elif currentNum < RED:
		add_theme_color_override("font_color", redColor)
