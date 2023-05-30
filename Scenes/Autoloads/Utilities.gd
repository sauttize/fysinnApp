extends Node
class_name Utility

enum MOUSE_BUTTON {LEFT, RIGHT, MIDDLE}

## Script with methods to make easier certain actions.

## Gets a Panel node and changes the color to the one chosen.
## Doesn't return anything because it just change the background color.
func changeFlatboxColor_Panel(panelNode : Panel, newColor : Color) -> void:
	var new_stylebox = panelNode.get_theme_stylebox("panel").duplicate()
	new_stylebox.bg_color = newColor
	panelNode.add_theme_stylebox_override("panel", new_stylebox)

## Gets a Label node and changes it's font color to the one chosen.
## No returns.
func changeFontColor_Label(labelNode : Label, newColor : Color) -> void:
	labelNode.add_theme_color_override("font_color", newColor)

## Gets an event and return true if is left mouse click pressed
func is_event_mouse_pressed(event : InputEvent, type : MOUSE_BUTTON):
	var button : int
	match type:
		MOUSE_BUTTON.LEFT:
			button = MOUSE_BUTTON_LEFT
		MOUSE_BUTTON.RIGHT:
			button = MOUSE_BUTTON_RIGHT
		MOUSE_BUTTON.MIDDLE:
			button = MOUSE_BUTTON_MIDDLE
	
	if !(event == InputEventMouseButton): return false
	var mouseEvent : InputEventMouseButton = event
	if !(mouseEvent.button_index == button): return false
	if mouseEvent.presse: return true
