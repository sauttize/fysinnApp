extends SpinBox

signal updateSAB(node : SpinBox, number : int)

func _check_text(new_text):
	if (int(new_text)):
		var number = int(new_text)
		updateSAB.emit(self, number)

func _on_sab_num_text_changed(new_text):
	_check_text(new_text)

func _on_control_update_bonuses(_fue, _des, _con, _inte, _sab, _car):
	updateSAB.emit(self, _sab)
