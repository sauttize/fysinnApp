extends Window
class_name QuickMessage

@onready var messageLabel : Label = $MarginContainer/MarginText/message
@onready var bg : Panel = $MarginContainer/bg
var bgColor : Color = Color.DIM_GRAY
var windowID : int

func _ready() -> void:
	size = Vector2(100, 100)
	close_requested.connect(hide)
	close_requested.connect(queue_free)

func updateNode(message : String, messageColor : Color, bgNewColor : Color):
	messageLabel.text = message
	Utilities.changeFontColor_Label(messageLabel, messageColor)
	Utilities.changeFlatboxColor_Panel(bg, bgNewColor)
