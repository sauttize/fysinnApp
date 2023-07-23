extends Control

signal exp_updated(opened : bool)

func _on_exp_window_visibility_changed():
	exp_updated.emit()

