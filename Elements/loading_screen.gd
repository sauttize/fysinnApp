extends CanvasLayer
class_name LoadingScreen

var window_size : Vector2i = Vector2i(450, 500)
@export var duration : int = 1.5
@onready var animationPlayer : AnimationPlayer = $"Dissolve Effect/AnimationPlayer"
var progress_status : int

func _ready() -> void:
	get_viewport().transparent_bg = true
	
	animationPlayer.play("new_animation")
	await get_tree().create_timer(duration).timeout
	animationPlayer.stop()
	animationPlayer.play("transition")
	await animationPlayer.animation_finished
	queue_free()

