extends MarginContainer

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@export_category("Profile")
var current_rel : Relationship
@export_subgroup("New relationship")
@export var new_rel_button : Button
@export var new_rel_window : Window
@export_subgroup("List")
@export var profileSlot : PackedScene
@export var list_parent : VBoxContainer
@export_subgroup("Output")
@export var output_view : VBoxContainer
@export var pic_texture : TextureRect
@export var name_label : RichTextLabel
@export var heart_textures : Array[TextureRect]
@export var type_label : RichTextLabel
@export var extra_info_label : TextEdit
@export_subgroup("Input")
@export var input_view : VBoxContainer
@export var edit_name : LineEdit
@export var edit_age : SpinBox
@export var sex_opt : OptionButton
@export var edit_hearts : SpinBox
@export var edit_type : LineEdit
@export var edit_button : Button
var output_shown : bool :
	get: return output_view.visible

func _ready() -> void:
	edit_button.pressed.connect(change_view)
	
	clean_all()
	fill_list_data()
	if !playerData.relationships.is_empty():
		current_rel = playerData.relationships[0]
		update_profile_info()
	else:
		edit_button.disabled = true
	
	extra_info_label.text_changed.connect(save_extra_info)
	new_rel_button.pressed.connect(new_rel_window.show)
	new_rel_window.rel_created.connect(fill_list_data)

## Update data
func clean_all() -> void:
	name_label.clear()
	GameTools.clean_heart_textures(heart_textures)
	type_label.clear()
	extra_info_label.clear()

func fill_list_data() -> void:
	for child in list_parent.get_children():
		child.queue_free()
	for rel in playerData.relationships:
		var new_slot = profileSlot.instantiate() as ProfileSlot
		list_parent.add_child(new_slot)
		new_slot.update_data(rel)
		new_slot.send_data.connect(get_data)

func get_data(rel : Relationship = current_rel) -> void:
	current_rel = rel
	edit_button.disabled = false
	update_profile_info()

func update_profile_info() -> void:
	clean_all()
	if current_rel.picture: pic_texture.texture = current_rel.picture
	var name_str := "%s (%s)%s" % [current_rel.rel_name, current_rel.age, current_rel.sex_emoji]
	name_label.append_text(name_str)
	GameTools.clean_heart_textures(heart_textures)
	GameTools.update_heart_textures(heart_textures, current_rel)
	type_label.append_text(current_rel.type)
	
	extra_info_label.text = current_rel.extra_info

func save_all_input() -> void:
	current_rel.rel_name = edit_name.text
	current_rel.age = edit_age.value
	match sex_opt.selected:
		0: current_rel.sex = "male"
		1: current_rel.sex = "female"
		2: current_rel.sex = "other"
	current_rel.hearts = clamp(edit_hearts.value, 0, 10)
	current_rel.type = edit_type.text
	update_profile_info()
	fill_list_data()

func save_extra_info() -> void:
	current_rel.extra_info = extra_info_label.text
	var ind : int = playerData.relationships.find(current_rel)
	if ind != -1: playerData.relationships[ind] = current_rel

## Edit Button
func change_view() -> void:
	match output_shown:
		true: # from Output view
			output_view.hide()
			input_view.show()
			if current_rel:
				edit_name.text = current_rel.rel_name
				edit_age.value = current_rel.age
				match current_rel.sex:
					"male": sex_opt.selected = 0
					"female": sex_opt.selected = 1
					_: sex_opt.selected = 2
				edit_hearts.value = current_rel.hearts
				edit_type.text = current_rel.type
		false: # from Input view
			input_view.hide()
			output_view.show()
			save_all_input()
