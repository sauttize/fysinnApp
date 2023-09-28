extends Window

const SAVE_NAME : String = 'playerData'
const EXT : String = '.tres'

@export var raceImages : Array[Texture2D]

@onready var bgColor : Panel = $bg
@onready var fileDialog : FileDialog = $"../FileDialog"

@onready var newName : LineEdit = $Control/form/name/nombre
@onready var newRace : OptionButton = $Control/form/race/raza
@onready var newClass : OptionButton = $Control/form/class/clase
@onready var newElement : OptionButton = $Control/form/element/elemento

@onready var getPhotoButton : Button = $Control/form/photo/Button
var newPhoto : ImageTexture
@onready var photoStatusLabel : Label = $Control/form/photo/elegida

@onready var newPlayerData : PlayerData = PlayerData.new()
@onready var createPlayerButton : Button = $Control/createCharacter

var dataDump : DataFile

func _ready() -> void:
	visibility_changed.connect(set_options)
	newClass.item_selected.connect(set_color_by_class)
	
	getPhotoButton.pressed.connect(fileDialog.show)
	fileDialog.close_requested.connect(fileDialog.hide)
	fileDialog.file_selected.connect(on_photo_chosen)
	createPlayerButton.pressed.connect(create_SaveFile)
	
	newRace.item_selected.connect(race_selected_anim)

func set_options():
	dataDump = GameManager.GetDataDump()
	newRace.clear()
	for race in dataDump.RACES_LIST:
		if race.name == "none": continue
		newRace.add_item(race.name)
	newClass.clear()
	for classType in dataDump.CLASSES_LIST:
		newClass.add_item(classType.getString())
	newElement.clear()
	for element in dataDump.ELEMENT_LIST:
		if element.getString() == "Propio": continue
		newElement.add_item(element.getString())
	newRace.selected = 2
	set_color_by_class(0)
	
func set_color_by_class(index : int):
	var str_ = newClass.get_item_text(index)
	var getClass = dataDump.stringToClass(str_)
	Utilities.changeFlatboxColor_Panel(bgColor, getClass.primaryColor)

func get_life(fromClass : ClassType) -> int:
	var maxLife : int = fromClass.hitPointMultiplier * fromClass.hitPointDice
	return maxLife

func check_data_is_filled() -> bool:
	if newName.text == '' || newRace.selected == -1: return false
	if newClass.selected == -1 || newElement.selected == -1: return false
	if !newPhoto: return false
	else: 
		return true

func create_SaveFile():
	if !check_data_is_filled(): Utilities.create_PopUp("Algunos campos no han sido llenados...", Color.RED, Color.BLACK)
	else:
		newPlayerData.nombre = newName.text
		newPlayerData.raza = dataDump.stringToRace(newRace.get_item_text(newRace.selected))
		newPlayerData.classtype = dataDump.stringToClass(newClass.get_item_text(newClass.selected))
		newPlayerData.elemento = dataDump.stringToElement(newElement.get_item_text(newElement.selected))
		newPlayerData.maxLife = get_life(newPlayerData.classtype)
		newPlayerData.currentLife = get_life(newPlayerData.classtype)
		newPlayerData.imagen = newPhoto
		newPlayerData.armor_equipped = ArmorSet.new()
		newPlayerData.customization = Customization.new()
		
#		newPlayerData.generate_id(GameManager.GetAllSaves())
		newPlayerData.new_knowledge_list(GameManager.GetDataDump())
		newPlayerData.max_motivation()
		newPlayerData.newSave()
#		ResourceSaver.save(newPlayerData, GameManager.SAVES_FOLDER_ROUTE + SAVE_NAME + str(dataDump.SAVES_INDEX) + EXT)
		GameManager.NewSave(newPlayerData)
		Utilities.create_PopUp("¡Tu personaje ha sido creado!")
		close_requested.emit()
## FILE DIALOG
func on_photo_chosen(path : String):
	var photo = Image.load_from_file(path)
	if photo:
		newPhoto = ImageTexture.create_from_image(photo)
		Utilities.changeFontColor_Label(photoStatusLabel, Color.LIME_GREEN)
		photoStatusLabel.text = 'nice!'
	else:
		Utilities.changeFontColor_Label(photoStatusLabel, Color.RED)
		photoStatusLabel.text = 'x'

func race_selected_anim(index : int):
	$RazaImagen.texture = raceImages[index]
	$PositionTween.play_Tween()
	$AlphaTween.play_Tween()
