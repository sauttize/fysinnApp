extends Panel
class_name ItemSlotButton

var item_attached : Item
@onready var item_label : RichTextLabel = $Label
var default_color : Color = Color('#353535')
var hover_color : Color = Color('#636363')

signal item_selected(item_res : Item)

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_left)
	
	update_name()

func update_name() -> void:
	item_label.clear()
	if item_attached:
		item_label.append_text("[center]" + item_attached.itemName + "[/center]")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed: item_selected.emit(item_attached)

func on_mouse_entered() -> void:
	Utilities.changeFlatboxColor_Panel(self, hover_color)

func on_mouse_left() -> void:
	Utilities.changeFlatboxColor_Panel(self, default_color)
