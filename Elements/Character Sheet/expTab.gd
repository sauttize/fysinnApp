extends Control

signal exp_updated()

func _on_exp_window_visibility_changed():
	emit_signal("exp_updated")

