extends Control

signal exp_updated()

func _on_exp_window_visibility_changed():
	emit_signal("exp_updated")

func _on_player_manager_update_all_info(data):
	$HBoxContainer/DisplayBox/Name.text = str(data.exp)
