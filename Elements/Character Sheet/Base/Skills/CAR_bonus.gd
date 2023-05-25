extends SpinBox

signal updateCAR(node : SpinBox, number : int)

func _check_text(new_text):
	if (int(new_text)):
		var number = int(new_text)
		updateCAR.emit(self, number)

func _on_car_num_text_changed(new_text):
	_check_text(new_text)

func _on_control_update_bonuses(_fue, _des, _con, _inte, _sab, _car):
	updateCAR.emit(self, _car)
