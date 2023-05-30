extends TextureRect

@export var normalColor : Color = Color.WHITE
@export var hoverColor : Color = Color.DIM_GRAY
@export var pressedColor : Color = Color.DARK_SLATE_GRAY

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
	modulate = pressedColor
	await get_tree().create_timer(1).timeout
	modulate = normalColor

func mouse_leave():
	modulate = normalColor
