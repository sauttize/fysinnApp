extends Window

@export var _warning : Window

@export var lifePoints : LineEdit
@export var maxPoints : LineEdit

signal addCurrent(value : int)
signal subCurrent(value : int)
signal updateMax(value : int)

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

#Hides warning window
func _on_warning_close_requested():
	_warning.hide()
