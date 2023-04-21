extends MarginContainer

signal updateBaseData(data : PlayerData)

# SKILLS
#Sets Skills data
func _on_player_manager_update_all_info(data):
	updateBaseData.emit(data)

# ARMOR
# Opens up edit temp armor window. (Also closes it)
func _on_edit_button_button_up():
	$Structure/Row1/ArmorVida/Armadura/AddTempArmor.popup_centered_clamped()
func _on_add_temp_armor_close_requested():
	$Structure/Row1/ArmorVida/Armadura/AddTempArmor.hide()

# LIFE
# Edit life window manager.
func _on_editar_vida_button_up():
	$Structure/Row1/ArmorVida/Vida/EditLife.popup_centered_clamped()
func _on_edit_life_close_requested():
	$Structure/Row1/ArmorVida/Vida/EditLife.hide()
