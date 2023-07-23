extends Window
@onready var player_data : PlayerData = GameManager.GetCurrentSaveFile()
@export var base_number_node : OptionButton
@export var multiplier_node : OptionButton
@export var aviso : Window

var base_number = 0
var multiplier = 0

# Adds exp to Player Data
func _on_button_button_up():
	# Get base node
	var base_number_id = base_number_node.get_selected()
	if !base_number_id == -1: 
		base_number = int(base_number_node.get_item_text(base_number_id))
	# Get multiplier
	var multiplier_id = multiplier_node.get_selected()
	if !multiplier_id == -1: 
		multiplier = int(multiplier_node.get_item_text(multiplier_id))
	#Final EXP
	if base_number_id != -1 && multiplier_id != -1:
		var exp_gained = base_number * multiplier
		player_data.updateExp(exp_gained)
		hide()
	else:
		aviso.popup_centered_clamped()

# Shows windows when edit button pressed.
func _on_edit_button_button_up() -> void:
	popup_centered_clamped()
func _on_close_requested():
	hide()
