extends SpinBox

signal updateDES(node : SpinBox, number : int)

func _check_text(new_text):
	if (int(new_text)):
		var number = int(new_text)
		updateDES.emit(self, number)

func _on_des_num_text_changed(new_text):
	_check_text(new_text)

func _on_control_update_bonuses(fue, des, con, inte, sab, car):
	updateDES.emit(self, des)
