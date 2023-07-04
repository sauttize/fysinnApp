extends MarginContainer

var thisEffect : Effect = Effect.new()

@onready var text : RichTextLabel = $elements/texto
@onready var bgPanel : Panel = $bg
@onready var activateBttn : Button = $elements/buttons/activar
@onready var deleteBttn : Button = $elements/buttons/eliminar

const NOMBRE : String = "[b]Nombre: [/b]"
const TIPO : String = "[b]Tipo: [/b]"
const DESCRIPCION : String = "[b]Descripción: [/b]"
const NL : String = "\n"

func update_effect(effect : Effect):
	thisEffect = effect
	text.append_text(NOMBRE + effect.effectName + NL)
	text.append_text(TIPO + effect.effectType + NL)
	text.append_text(DESCRIPCION + effect.effectDescription)
	
	Utilities.changeFlatboxColor_Panel(bgPanel, effect.getColor())
	activateBttn.show() if effect.isActivable else activateBttn.hide()
	deleteBttn.show() if effect.isRemovable else deleteBttn.hide()
