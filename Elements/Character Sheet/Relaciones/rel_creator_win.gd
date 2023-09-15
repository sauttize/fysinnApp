extends Window

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@export var create_button : Button
@export_subgroup("Input fields")
@export var name_edit : LineEdit
@export var age_edit : SpinBox
@export var sex_opt : OptionButton
@export var type_edit : LineEdit
@export_subgroup("Picture")
var picture : ImageTexture
@export var select_pic_button : Button
@export var is_selected_label : Label
@export var file_window : FileDialog

signal rel_created()

func _ready() -> void:
	create_button.pressed.connect(create_rel)
	close_requested.connect(hide_and_clear)
	
	select_pic_button.pressed.connect(file_window.show)
	file_window.file_selected.connect(get_picture)
	file_window.close_requested.connect(file_window.hide)
	
func create_rel() -> void:
	if name_edit.text == "":
		Utilities.create_PopUp("Debes ingresar un nombre")
		return
	
	var new_rel : Relationship = Relationship.new()
	new_rel.rel_name = name_edit.text
	new_rel.age = age_edit.value
	match sex_opt.selected:
		0: new_rel.sex = "male"
		1: new_rel.sex = "female"
		2: new_rel.sex = "other"
	new_rel.type = type_edit.text
	if picture:
		new_rel.picture = picture
	
	playerData.relationships.append(new_rel)
	Utilities.create_PopUp("¡Relación añadida con exito!")
	rel_created.emit()
	hide_and_clear()

func get_picture(path : String) -> void:
	var image := Image.load_from_file(path)
	var texture = ImageTexture.create_from_image(image)
	picture = texture
	is_selected_label.text = "✓"
	Utilities.changeFontColor_Label(is_selected_label, Color.SEA_GREEN)

func hide_and_clear() -> void:
	hide()
	name_edit.text = ""
	age_edit.value = 0
	sex_opt.selected = 0
	type_edit.text = ""
	picture = null
	is_selected_label.text = "x"
	Utilities.changeFontColor_Label(is_selected_label, Color.DARK_RED)
