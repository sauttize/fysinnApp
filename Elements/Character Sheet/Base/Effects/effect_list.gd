extends ScrollContainer
class_name EffectList

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@onready var effectSlot = preload("res://Elements/Character Sheet/Base/Effects/effect_slot.tscn")
@onready var effectList : VBoxContainer = $efectos

func _ready() -> void:
	updateEffects()

func updateEffects():
	clearList()
	for effect in playerData.activeEffects:
		var newSlot = effectSlot.instantiate() as EffectSlot
		newSlot.effectDeleted.connect(updateEffects)
		effectList.add_child(newSlot)
		newSlot.update_effect(effect)

func clearList():
	for eff in effectList.get_children():
		eff.queue_free()
