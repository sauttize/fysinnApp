extends Control

@export var playerData : PlayerData

#TABS
@export var picNode : Control
@export var statsNode : Control

#IMAGE
@export var currentPic : TextureRect


var isPicShowing = true

func _ready():
	_updateData()

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
	var newImage = Image.load_from_file(path)
	var newTex = ImageTexture.create_from_image(newImage)
	playerData.imagen = newTex
	_updateData()
