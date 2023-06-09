extends Node
@onready var exitDialog : ConfirmationDialog = $"../ExitConfirmation"
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@onready var savesManager : SaveFilesManager = GameManager.GetManager()

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
	ResourceSaver.save(playerData, GameManager.SAVE_ROUTE)
	if savesManager.numberOfSaves > 0:
		var getDuplicate = playerData.duplicate()
		var saveIndex = playerData.saveManagerIndex ##
		if saveIndex != -1:
			savesManager.save_files[saveIndex] = getDuplicate
			get_tree().quit()
		else:
			Utilities.create_PopUp("Save not assigned in save manager \n Not saving nor exiting! ...") 
# ----------------------------------
