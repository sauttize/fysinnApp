extends Node
@export var exitDialog : ConfirmationDialog
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

func _ready() -> void:
	# So I doesn't close automatically
	get_tree().set_auto_accept_quit(false)
	exitDialog.canceled.connect(canceled_saveOnExit)
	exitDialog.confirmed.connect(accepted_saveOnExit)

# -------- EXIT MANAGEMENT ---------
func _notification(what: int) -> void:
	if (what == 1006):
		exitDialog.popup_centered_clamped()

func canceled_saveOnExit():
	get_tree().quit()
func accepted_saveOnExit():
	if playerData.nombre != "name":
		GameManager.UpdateOriginalSaveFile()
		get_tree().quit()
	else:
		Utilities.create_PopUp("Error \n Not saving nor exiting! ...") 
# ----------------------------------
