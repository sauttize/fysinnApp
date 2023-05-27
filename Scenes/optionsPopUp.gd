extends MenuButton

var popup : PopupMenu

# AutoGuardado:
@export_category("AutoSave")
@export var playerData : PlayerData
var isCheck : bool
@export var timer : Timer
@export var intervalMin : float = 5 #min

func _ready() -> void:
	popup = get_popup()
	popup.id_pressed.connect(click_op)
	
	#autosave initial setting
	update_autosave_interval(intervalMin)
	timer.timeout.connect(autosave)
	isCheck = popup.is_item_checked(0)
	update_autosave(isCheck)
	
func click_op(id : int):
	if (id == 0):
		isCheck = !popup.is_item_checked(0)
		popup.set_item_checked(0, isCheck)
		update_autosave(isCheck)

# --- AutoSave ---
func autosave():
	ResourceSaver.save(playerData, GameManager.SAVE_ROUTE)

func update_autosave(isActive : bool):
	if isActive: timer.start()
	else: timer.stop()

func update_autosave_interval(minutes : float):
	var intervalSeconds = minutes * 60 # min to sec
	timer.wait_time = intervalSeconds
# -----------------
