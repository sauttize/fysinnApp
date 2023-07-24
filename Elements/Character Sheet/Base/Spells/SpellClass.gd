extends Control
class_name SpellSlot

@export var spellData : Spell

# BUTTONS
@onready var moreInfoButton : Button = $margin/container/Button

# BASIC INFO
@onready var labName : Label  = $margin/container/labels/spellName
@onready var labLevel : Label = $margin/container/labels/nivel

# WINDOW NODES
@onready var window : Window = $SpellInfo

func _ready() -> void:
	#buttons set up
	moreInfoButton.button_up.connect(showWindow)
	
	window.close_requested.connect(hideWindow)

func update_Basics(newSpell):
	if newSpell == null: 
		spellData = null
		labName.text = "-"
		labLevel.text = "niv: " 
	else:
		spellData = newSpell
		labName.text = spellData.spellName
		labLevel.text = "niv: " + str(spellData.level)

# WINDOW
func showWindow():
	if(spellData):
		window.show()
		window.update_Complete(spellData)

func hideWindow():
	window.hide()
