extends TextureRect
class_name TextureToButton

@export var normalColor : Color = Color.WHITE
@export var hoverColor : Color = Color.DIM_GRAY
@export var pressedColor : Color = Color.DARK_SLATE_GRAY
@export_range(0, 0.5) var pressedTime : float = 0.2
@export_subgroup("Window")
@export var openWindow : Window 
@export var internalClose : bool = true
var closedConnected : bool = false

signal on_button_pressed

func _ready():
	modulate = normalColor
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_entered.connect(mouse_enter)
	mouse_exited.connect(mouse_leave)
	gui_input.connect(button_pressed)

func mouse_enter():
	modulate = hoverColor

func button_pressed(event):
	if !(Utilities.is_event_mouse_pressed(event, Utilities.MOUSE_BUTTON.LEFT)): 
		return
	on_button_pressed.emit()
	modulate = pressedColor
	# If there's a window to open
	if openWindow:
		if internalClose && !closedConnected: 
			openWindow.close_requested.connect(openWindow.hide)
			closedConnected = true
		openWindow.popup_centered_clamped()
	# ---------
	await get_tree().create_timer(pressedTime).timeout
	modulate = normalColor

func mouse_leave():
	modulate = normalColor
