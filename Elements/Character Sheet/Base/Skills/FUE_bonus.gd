extends SpinBox

signal updateSKILL(node : SpinBox, number : int)

func _on_fue_num_text_changed(new_text):
	if (int(new_text)):
		var number = int(new_text)
		updateSKILL.emit(self, number)

func _on_control_update_bonuses(_num1, _num2, _num3, _num4, _num5, _num6):
	updateSKILL.emit(self, _num1)
