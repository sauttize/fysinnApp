extends Label

@export var playerData : PlayerData
@export var hoverColor : Color
@export var infoWindow : Window

func _ready() -> void:
	if playerData:
		text = playerData.elemento.getString()
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	self.mouse_entered.connect(mouseHover)
	self.mouse_exited.connect(mouseHoverExit)
	
func mouseHover():
	add_theme_color_override("font_color", hoverColor)
	
func mouseHoverExit():
	add_theme_color_override("font_color", Color.WHITE)
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			infoWindow.loadData()
			infoWindow.popup_centered_clamped()
