extends Window
class_name Info_Elemental

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@onready var fortalezasText : RichTextLabel = $container/vbox/hbox/fortalezas/lista
@onready var debilidadesText : RichTextLabel = $container/vbox/hbox/debilidades/lista
var disposable : bool = false

func _ready() -> void:
	self.close_requested.connect(closeWindow)

func loadData():
	if playerData:
		for element in playerData.elemento.getSrengthString():
			fortalezasText.text += "- " + element + "\n"
		for element in playerData.elemento.getWeaknessString():
			debilidadesText.text += "- " + element + "\n"

func readElement(elemento : Element):
	disposable = true
	if elemento.element == Element.ELEMENTS.Propio:
		loadData()
	else:
		for element in elemento.getSrengthString():
				fortalezasText.text += "- " + element + "\n"
		for element in elemento.getWeaknessString():
			debilidadesText.text += "- " + element + "\n"

func closeWindow():
	hide()
	fortalezasText.text = ""
	debilidadesText.text = ""
	if disposable: queue_free()
