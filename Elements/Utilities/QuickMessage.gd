extends Window
class_name QuickMessage

@onready var messageLabel : Label = $message
@onready var bg : Panel = $bg
var bgColor : Color = Color.DIM_GRAY

func _ready() -> void:
	close_requested.connect(hide)
	close_requested.connect(queue_free)

func updateNode(message : String, messageColor : Color, bgNewColor : Color):
	messageLabel.text = message
	Utilities.changeFontColor_Label(messageLabel, messageColor)
	Utilities.changeFlatboxColor_Panel(bg, bgNewColor)
