extends MarginContainer

@export var historialPanelPos : PositionTween 

func _ready() -> void:
	visibility_changed.connect(play_animations)
	
func play_animations():
	historialPanelPos.play_Tween()
