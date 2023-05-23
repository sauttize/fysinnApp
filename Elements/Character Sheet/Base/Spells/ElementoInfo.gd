extends Window

@export var playerData : PlayerData
@export_category("RichTextLabel")
@export var fortalezasText : RichTextLabel
@export var debilidadesText : RichTextLabel

func _ready() -> void:
	self.close_requested.connect(closeWindow)

func loadData():
	if playerData:
		for element in playerData.elemento.getSrengthString():
			fortalezasText.text += "- " + element + "\n"
		for element in playerData.elemento.getWeaknessString():
			debilidadesText.text += "- " + element + "\n"

func closeWindow():
	hide()
	fortalezasText.text = ""
	debilidadesText.text = ""
