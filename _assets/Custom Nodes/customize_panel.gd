extends Node
class_name CustomizePanel

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@export var panel_id : String
@export var panel_node : Control
@export var color_picker_button : ColorPickerButton
@export var default_color : Color
@export_subgroup("Optional")
@export var use_modulate : bool = false
@export var depend_on : Control ## This node needs to be visible for input to be read
@export_subgroup("Parent (Just link one)")
@export var hide_parent : bool = false
@export var parent_node : Control


func _ready() -> void:
	if !panel_node or !color_picker_button:
		push_error("Missing dependencies in node %s" % name)
		return
	
	if !playerData.customization: playerData.customization = Customization.new()
	if panel_id:
		var color = playerData.customization.get(panel_id)
		print(color)
		if color && color is Color:
			if use_modulate: panel_node.modulate = color
			else: Utilities.changeFlatboxColor_Panel(panel_node, color)
			color_picker_button.color = color
		else:
			push_error("Variable not found in customization resource. Check naming. (%s)" % [get_parent().name])
	
	color_picker_button.color_changed.connect(change_panel_color)
	color_picker_button.popup_closed.connect(save_color)

func _input(event: InputEvent) -> void:
	if !panel_node or !color_picker_button:
		push_error("Missing dependencies in node %s" % name)
		return
	if panel_node.visible && owner.visible:
		if depend_on && !depend_on.visible: return
		if event.is_action_pressed("show_colorpicker"):
			color_picker_button.visible = !color_picker_button.visible
			if hide_parent && parent_node:
				parent_node.visible = !parent_node.visible
		if event.is_action_pressed("default_color"):
			color_picker_button.color = default_color
			if use_modulate: panel_node.modulate = default_color
			else: Utilities.changeFlatboxColor_Panel(panel_node, default_color)
			save_color()

func change_panel_color(new_color : Color) -> void:
	if use_modulate: panel_node.modulate = new_color
	else: Utilities.changeFlatboxColor_Panel(panel_node, new_color)

func save_color() -> void:
	var new_color : Color = color_picker_button.color
	if panel_id:
		if playerData.customization.get(panel_id):
			playerData.customization.set(panel_id, new_color)
			print(playerData.customization.get(panel_id))
			
