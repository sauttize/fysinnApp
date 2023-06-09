extends Node
class_name AlphaTween

#Tween
@export var node : Node
@export_category("Tween")
@export var startAtReady : bool = true
@export var parallelToPrevious : bool = false
@export_range(0, 10) var duration : float = 1.7
@export var easeType : Tween.EaseType = Tween.EASE_IN_OUT
@export var transitionType : Tween.TransitionType = Tween.TRANS_BACK
@export_range(0,1) var fromAplhaValue : float = 0
@export_range(0,1) var toAplhaValue : float = 1

func _ready():
	if(node && startAtReady):
		play_Tween()
	elif (startAtReady): 
		print("Node not assign in Tween Animation.")
		print(get_path())

func play_Tween():
	var tween = create_tween().set_ease(easeType).set_trans(transitionType)
	if parallelToPrevious: tween.parallel()
	tween.tween_property(node, "modulate", Color(1,1,1,toAplhaValue), duration).from(Color(1,1,1,fromAplhaValue))
