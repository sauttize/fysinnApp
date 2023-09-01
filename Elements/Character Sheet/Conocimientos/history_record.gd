extends PanelContainer
class_name KnowledgeRecordSlot

@export var this_record : KnowledgeRecord
@onready var label : RichTextLabel = $MarginContainer/Label
@onready var delete_button : Button = $Button

func _ready() -> void:
	delete_button.pressed.connect(delete_record)

func delete_record() -> void:
	var playerData= GameManager.GetCurrentSaveFile() as PlayerData
	playerData.knowl_history.erase(this_record)
	queue_free()
	
func update_label() -> void:
	label.clear()
	if this_record:
		label.append_text(this_record.content)
	else:
		label.append_text("Error obteniendo registro.")
