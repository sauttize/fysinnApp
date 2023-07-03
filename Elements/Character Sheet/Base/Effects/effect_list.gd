extends VFlowContainer

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@onready var effectSlot = preload("res://Elements/Character Sheet/Base/Effects/effect_slot.tscn")

func _ready() -> void:
	for effect in playerData.active_effects:
		var newSlot = effectSlot.instantiate()
		newSlot.update_effect(effect)
		add_child(newSlot)
