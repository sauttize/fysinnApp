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
func is_event_mouse_pressed(event : InputEvent, type : MOUSE_BUTTON) -> bool:
	var button : int
	match type:
		MOUSE_BUTTON.LEFT:
			button = MOUSE_BUTTON_LEFT
		MOUSE_BUTTON.RIGHT:
			button = MOUSE_BUTTON_RIGHT
		MOUSE_BUTTON.MIDDLE:
			button = MOUSE_BUTTON_MIDDLE
	
	if !(event is InputEventMouseButton): return false
	var mouseEvent : InputEventMouseButton = event
	if !(mouseEvent.button_index == button): return false
	if !(mouseEvent.is_pressed()) : return false
	return true

func FULL_DATE() -> String:
	return Time.get_datetime_string_from_system()

## NOT FINSHED
func get_date_diff(current : Dictionary, old : Dictionary, getHour : bool = false):
	if !current['year'] || !current['month'] || !current['day']: return
	if !current['hour'] || !current['minute'] || !current['second']: return
	if !old['year'] || !old['month'] || !old['day']: return
	if !old['hour'] || !old['minute'] || !old['second']: return
	
	if (current['year'] == old['year']) && (current['month'] == old['month']):
		if (current['day'] == old['day']) && (current['hour'] == old['hour']):
			pass

## Create popup Window with simple text message
func create_PopUp(message : String = "hello"):
	var window = Window.new()
	window.transient = true
	window.wrap_controls = true
	window.exclusive = true
	window.unresizable = true
	var label = Label.new()
	label.text = message
	add_child(window)
	window.add_child(label)
	window.get_child(0).set_anchors_preset(Control.PRESET_CENTER)
	window.child_controls_changed()
	window.close_requested.connect(window.hide)
	window.close_requested.connect(erase_PopUp.bind(window))
	window.popup_centered_clamped()
func erase_PopUp(window : Window):
	window.queue_free()
