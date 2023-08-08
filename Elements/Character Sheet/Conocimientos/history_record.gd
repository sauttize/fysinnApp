extends PanelContainer
class_name KnowledgeRecordSlot

@export var this_record : KnowledgeRecord
@onready var label : RichTextLabel = $MarginContainer/Label

func update_label() -> void:
	if this_record:
		label.append_text(this_record.content)
	else:
		label.append_text("Error obteniendo registro.")
