extends MarginContainer
class_name EffectSlot

var thisEffect : Effect = Effect.new()
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@onready var text : RichTextLabel = $elements/texto
@onready var bgPanel : Panel = $bg
@onready var activateBttn : Button = $elements/buttons/activar
@onready var deleteBttn : Button = $elements/buttons/eliminar
@onready var infoBttn : Button = $elements/info
@onready var infoWindow : Window = $Description
@onready var infoWin_Description : RichTextLabel = $Description/MarginContainer/VBoxContainer/Descripcion

const NOMBRE : String = "[b]Nombre: [/b]"
const TIPO : String = "[b]Tipo: [/b]"
const DESCRIPCION : String = "[b]Descripción: [/b]"
const NL : String = "\n"

signal effectDeleted

func update_effect(effect : Effect):
	thisEffect = effect
	text.append_text(NOMBRE + effect.effectName + NL)
	text.append_text(TIPO + effect.effectType + NL)
	
	infoWin_Description.clear()
	infoWin_Description.append_text(effect.effectDescription)
	
	Utilities.changeFlatboxColor_Panel(bgPanel, effect.getColor())
	infoBttn.pressed.connect(infoWindow.show)
	infoWindow.close_requested.connect(infoWindow.hide)
	
	activateBttn.show() if effect.isActivable else activateBttn.hide()
	deleteBttn.show() if effect.isRemovable else deleteBttn.hide()
	deleteBttn.pressed.connect(delete_effect_from_player)

func delete_effect_from_player():
	var index = playerData.activeEffects.find(thisEffect)
	if index != -1:
		playerData.activeEffects.remove_at(index)
		GameManager.UpdateOriginalSaveFile()
		effectDeleted.emit()
		if OS.is_debug_build(): 
			print(thisEffect.effectName + " sucessfully deleted.")
	else:
		print("error in " + str(get_path()))

func show_information():
	Utilities.create_PopUp(DESCRIPCION + thisEffect.effectDescription, Color.AZURE, Color.DIM_GRAY)
