extends Window

@export var _warning : Window

@export var lifePoints : LineEdit
@export var maxPoints : LineEdit

@export_category("Buttons")
@export var heal_bttn : Button
@export var damage_bttn : Button
@export var mod_max_bttn : Button

signal addCurrent(value : int)
signal subCurrent(value : int)
signal updateMax(value : int)

func _ready() -> void:
	heal_bttn.pressed.connect(_on_curarbtn_button_up)
	damage_bttn.pressed.connect(_on_herirbtn_button_up)
	mod_max_bttn.pressed.connect(_on_max_btn_button_up)
	
	_warning.close_requested.connect(_warning.hide)
	
	close_requested.connect(hide)
	
#HEAL
func _on_curarbtn_button_up():
	if (int(lifePoints.text)):
		addCurrent.emit(int(lifePoints.text))
		hide()
	else:
		_warning.show()

#HURT
func _on_herirbtn_button_up():
	if (int(lifePoints.text)):
		subCurrent.emit(int(lifePoints.text))
		hide()
	else:
		_warning.show()

#ADD MAX
func _on_max_btn_button_up():
	if (int(maxPoints.text)):
		updateMax.emit(int(maxPoints.text))
		hide()
	else:
		_warning.show()

