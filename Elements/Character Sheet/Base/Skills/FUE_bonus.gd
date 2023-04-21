extends SpinBox

signal updateSKILL(node : SpinBox, number : int)

func _on_fue_num_text_changed(new_text):
	if (int(new_text)):
		var number = int(new_text)
		updateSKILL.emit(self, number)

func _on_control_update_bonuses(num1, num2, num3, num4, num5, num6):
	updateSKILL.emit(self, num1)
