extends Node
@onready var exitDialog : ConfirmationDialog = $"../ExitConfirmation"
@export var playerData : PlayerData

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
	ResourceSaver.save(playerData, GameManager.save_file_path + GameManager.save_file_name)
	get_tree().quit()
# ----------------------------------
