extends Control
class_name SaveSlot

@onready var savePhoto : TextureRect = $profilePic
@onready var saveName : Label = $datos/nombre
@onready var saveRace : Label = $datos/razaClase/raza
@onready var saveClass : Label = $datos/razaClase/clase
@onready var saveLvl : Label = $datos/nivel

@onready var enterButton : Button = $buttons/enter
@onready var deleteButton : Button = $buttons/delete

func set_data(playerData : PlayerData, isEnterButton : bool = false, isDeleteButton : bool = false):
	savePhoto.texture = playerData.imagen
	saveName.text = playerData.nombre
	saveRace.text = playerData.raza.name
	saveClass.text = playerData.classtype.getString()
	saveLvl.text = str(playerData.nivel)
	
	if isEnterButton: enterButton.visible = true
	if isDeleteButton: deleteButton.visible = true
