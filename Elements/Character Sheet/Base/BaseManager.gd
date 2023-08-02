extends MarginContainer

@export var editLife : Window
@export var editArmor : Window

@export_category("Managers")
@export var effect_list : EffectList
@export var inventory : ScrollContainer

signal updateBaseData()

func _ready():
	visibility_changed.connect(refresh_data)

func refresh_data():
	effect_list.updateEffects()
	inventory.update_all()

# SKILLS
#Sets Skills data
func _on_player_manager_update_all_info():
	updateBaseData.emit()

# ARMOR
# Opens up edit temp armor window. (Also closes it)
func _on_edit_button_button_up():
	editArmor.popup_centered_clamped()
func _on_add_temp_armor_close_requested():
	editArmor.hide()

# LIFE
# Edit life window manager.
func _on_editar_vida_button_up():
	editLife.popup_centered_clamped()
func _on_edit_life_close_requested():
	editLife.hide()
