extends MarginContainer
class_name EffectSlot

var thisEffect : Effect = Effect.new()
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@onready var text : RichTextLabel = $elements/texto
@onready var bgPanel : Panel = $bg
@onready var activateBttn : Button = $elements/buttons/activar
@onready var deleteBttn : Button = $elements/buttons/eliminar

const NOMBRE : String = "[b]Nombre: [/b]"
const TIPO : String = "[b]Tipo: [/b]"
const DESCRIPCION : String = "[b]Descripción: [/b]"
const NL : String = "\n"

signal effectDeleted

func update_effect(effect : Effect):
	thisEffect = effect
	text.append_text(NOMBRE + effect.effectName + NL)
	text.append_text(TIPO + effect.effectType + NL)
	text.append_text(DESCRIPCION + effect.effectDescription)
	
	Utilities.changeFlatboxColor_Panel(bgPanel, effect.getColor())
	activateBttn.show() if effect.isActivable else activateBttn.hide()
	deleteBttn.show() if effect.isRemovable else deleteBttn.hide()
	deleteBttn.pressed.connect(delete_effect_from_player)

func delete_effect_from_player():
	for eff in playerData.activeEffects:
		if thisEffect == eff:
			playerData.activeEffects.erase(eff)
			GameManager.UpdateOriginalSaveFile()
			effectDeleted.emit()
			if OS.is_debug_build(): 
				print(eff.effectName + " sucessfully deleted.")
