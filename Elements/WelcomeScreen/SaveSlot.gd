extends Control
class_name SaveSlot

var thisPlayerData : PlayerData

@onready var savePhoto : TextureRect = $picContainer/profilePic
@onready var saveName : Label = $datos/nombre
@onready var saveRace : Label = $datos/razaClase/raza
@onready var saveClass : Label = $datos/razaClase/clase
@onready var saveLvl : Label = $datos/nivel

@onready var enterButton : Button = $buttons/enter
@onready var deleteButton : Button = $buttons/delete

func set_data(playerData : PlayerData, isEnterButton : bool = false, isDeleteButton : bool = false):
	thisPlayerData = playerData
	
	savePhoto.texture = playerData.imagen
	saveName.text = playerData.nombre
	saveRace.text = playerData.raza.name
	saveClass.text = playerData.classtype.getString()
	saveLvl.text = str(playerData.nivel)
	
	if isEnterButton: 
		enterButton.visible = true
		enterButton.pressed.connect(enter_pressed)
	if isDeleteButton: 
		deleteButton.visible = true
		deleteButton.pressed.connect(delete_pressed)

func enter_pressed():
	GameManager.UpdateCurrentPD(thisPlayerData)
	get_parent().queue_free()
	get_tree().change_scene_to_file("res://Scenes/PlayerScene.tscn")

func delete_pressed():
	GameManager.DeleteSave(thisPlayerData)
	Utilities.create_PopUp("Archivo eliminado")
	queue_free()
