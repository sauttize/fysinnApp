extends Button
class_name ProfileSlot

@export var current_rel : Relationship
@onready var pic_text : TextureRect = $HBoxContainer/Panel/TextureRect
@onready var name_label : RichTextLabel = $HBoxContainer/Data/Name
@onready var type_label : RichTextLabel = $HBoxContainer/Data/Type
@export_range(0, 10) var heart_num : int = 0
@onready var heart_list : HBoxContainer = $HBoxContainer/Data/Hearts
@export var heart_textures : Array[TextureRect]

signal send_data(data : Relationship)

func _ready() -> void:
	pressed.connect(send_rel)
	get_texturerect()

func update_data(relationship : Relationship) -> void:
	current_rel = relationship
	
	if (current_rel.picture): pic_text.texture = current_rel.picture
	var rel_name := current_rel.rel_name
	var age := current_rel.age
	var sex_symbol := current_rel.sex_emoji
	name_label.clear()
	name_label.append_text("%s (%s)%s" % [rel_name, age, sex_symbol])
	type_label.clear()
	type_label.append_text(current_rel.type)
	
	GameTools.clean_heart_textures(heart_textures)
	GameTools.update_heart_textures(heart_textures, current_rel)

func get_texturerect() -> void:
	for texture in heart_list.get_children():
		heart_textures.append(texture)

func send_rel() -> void:
	send_data.emit(current_rel)
