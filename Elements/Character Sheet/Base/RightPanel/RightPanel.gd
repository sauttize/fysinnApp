extends Control

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

#TABS
@export var picNode : Control
@export var statsNode : Control

#IMAGE
@export var currentPic : TextureRect


var isPicShowing = true

func _ready():
	_updateData()
	
	get_tree().get_root().files_dropped.connect(file_dropped)

func _updateData():
	if (playerData.imagen):
		currentPic.texture = playerData.imagen
	else:
		var image = Image.load_from_file("res://_assets/Images/profilepic/test.jpg")
		playerData.imagen = ImageTexture.create_from_image(image)
		_updateData()

func _change_tab():
	if(isPicShowing):
		isPicShowing = false
		picNode.hide()
		statsNode.show()
	else:
		isPicShowing = true
		statsNode.hide()
		picNode.show()

func _on_change_button_up():
	_change_tab()

#Changing image
func _on_edit_button_button_up():
	#Creates a file dialog asking for the pic
	$picture/FileDialog.popup_centered_clamped()

func _on_file_dialog_file_selected(path):
	change_image(path)

func change_image(path):
	var newImage = Image.load_from_file(path)
	var newTex = ImageTexture.create_from_image(newImage)
	playerData.imagen = newTex
	_updateData()

## Drop image options
func file_dropped(files_path : PackedStringArray) -> void:
	if is_visible_in_tree() != true: return # If it's outside inventory tab
	await get_tree().create_timer(0.2).timeout
	
	if files_path.size() == 1:
		var err = Image.new().load(files_path[0])
		if err == OK:
			var new_img = Image.load_from_file(files_path[0])
			var new_text = ImageTexture.create_from_image(new_img)
			playerData.imagen = new_text
			Utilities.create_PopUp("Imagen cambiada correctamente!")
			_updateData()
	else:
		Utilities.create_PopUp("Solo puedes arrastrar una imagen.")
