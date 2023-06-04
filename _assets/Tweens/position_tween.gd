extends Node
class_name PositionTween

#Tween
@export var node : Control
@export_category("Tween")
@export var startAtReady : bool = true
@export var parallelToPrevious : bool = false
@export_range(0, 10) var duration : float = 1.5
@export var easeType : Tween.EaseType = Tween.EASE_IN_OUT
@export var transitionType : Tween.TransitionType = Tween.TRANS_BACK
@export var newStartingPosition : bool = false
@export var fromPosition2D : Vector2 = Vector2(0, 0)
@export var toPosition2D : Vector2 = Vector2(0, 0)

func _ready():
	if(node && startAtReady):
		play_Tween()
	else: 
		print("Node not assign in Tween Animation.")

func play_Tween():
	var tween = create_tween().set_ease(easeType).set_trans(transitionType)
	if parallelToPrevious: tween.parallel()
	if(newStartingPosition):
		tween.tween_property(node, "position", toPosition2D, duration).from(fromPosition2D)
	else:
		tween.tween_property(node, "position", toPosition2D, duration)
