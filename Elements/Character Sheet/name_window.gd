extends Window

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
var newName

# Change player name.
func _on_button_button_up():
	newName = $MarginContainer/VBoxContainer/LineEdit.text
	
	$ConfirmationDialog.popup_centered_clamped()
## Confirman cambio.
func _on_confirmation_dialog_confirmed():
	playerData.nombre = newName
	hide()


# Shows and hides window
func _on_texture_button_button_up():
	popup_centered_clamped()
func _on_close_requested():
	hide()
