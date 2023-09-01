extends MarginContainer

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@export_category("Knowledges")
@export var knowl_list : KnowledgeList
@export_category("History")
@export var historialPanelPos : PositionTween 
@export var historialList : VBoxContainer
@export var history_slot : PackedScene


func _ready() -> void:
	visibility_changed.connect(play_animations)
	update_history()
	
	knowl_list.update_history.connect(update_history)
	
func play_animations():
	historialPanelPos.play_Tween()

## HISTORY
func update_history() -> void:
	clean_history()
	for record in playerData.knowl_history:
		var new_slot = history_slot.instantiate() as KnowledgeRecordSlot
		new_slot.this_record = record
		historialList.add_child(new_slot)
		historialList.move_child(new_slot, 0)
		new_slot.update_label()


func clean_history() -> void:
	for node in historialList.get_children():
		node.queue_free()
