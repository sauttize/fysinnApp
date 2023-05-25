extends SpinBox

signal updateCON(node : SpinBox, number : int)

func _check_text(new_text):
	if (int(new_text)):
		var number = int(new_text)
		updateCON.emit(self, number)
		
func _on_con_num_text_changed(new_text):
	_check_text(new_text)

func _on_control_update_bonuses(_fue, _des, _con, _inte, _sab, _car):
	updateCON.emit(self, _con)
