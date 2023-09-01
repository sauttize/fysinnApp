extends Resource
class_name KnowledgeRecord

enum THROW {SPECIAL, NORMAL}

@export var content : String = "" ## Final output of the record
@export var associated_knowl : Knowledge ## Knowledge resource associated
## If the user has any proficiency type with that knowledge, then it's true
@export var with_proficiency : bool = false 
@export var throw_type : THROW ## Used with stats or as knowledge
@export_enum("Exito", "Fallo") var result : String ## User got enough number or not
@export var number_needed : int = 0 
@export var number_got : int = 0
@export_subgroup("Effect")
@export var was_effect : bool = false ## If the record is about an effect being used, it's true.
@export var associated_eff : Array[Effect] ## The effect used.

const FONT_SIZE : float = 10
const EXITO : String = "[i][color=green]Exito! ;)[/color][/i]" ## Success message
const FALLO : String = "[i][color=red]Fallo! :c[/color][/i]" ## Failing message
const ACTIVADO : String = "[i][color=lightblue]Efecto activado[/color][/i]" ## For effect activation

## Main functions

func create_special_record(knowl: Knowledge, success: bool) -> String:
	var res : String = ""
	# Knowledge name
	res += "[b]%s[/b] " % [knowl.knowledgeName]
	res += "(Tirada especial)"
	# Success or failure
	res += "\n"
	if success: res += EXITO
	else: res += FALLO
	
	content = res
	throw_type = THROW.SPECIAL
	return res

## With the given input, fills the record as normal record, meaning: no effect.
func create_normal_record(knowl : Knowledge, needed_num : int, got_num : int,prof_num : int = 0) -> String:
	associated_knowl = knowl
	number_needed = needed_num
	number_got = got_num
	if prof_num > 0: with_proficiency = true
	
	var res : String = ""
	# Knowledge name
	res += "[b]%s[/b] " % [knowl.knowledgeName]
	# Throw type
	res += "(Tirada normal)"
	# With proficiency?
	if with_proficiency: res += " [i]+ prof %s[/i]" % [prof_num]
	# Success or failure
	res += "\n"
	if number_got >= number_needed:
		res += EXITO
	else:
		res += FALLO
	# Number record
	res += "\n"
	res += BB_need_got(number_needed, number_got)
	
	content = res
	throw_type = THROW.NORMAL
	return res
##  With the given input, fills the record as effect record.
func create_effect_record(knowl : Knowledge) -> String:
	var res : String = ""
	res += "[b]%s[/b]\n" % [knowl.knowledgeName]
	if knowl.associatedEffects.size() == 0:
		res += "[i]Error utilizando efectos. Dicho conocimiento no tiene efectos asociados.[/i]"
	else:
		associated_knowl = knowl
		associated_eff = knowl.associatedEffects
		res += ACTIVADO + "\n"
		res += BB_effects_activated(associated_eff)
	content = res
	return res

## Learning records
func create_learn_record(knowl : Knowledge, learn_type : String, success : bool) -> String:
	var res : String = ""
	# Knowledge name
	res += "[b]%s[/b] " % [knowl.knowledgeName]
	res += "\n(Aprendizaje por: %s)" % learn_type
	# Success or failure
	var left_text = ""
	res += "\n"
	if success: 
		res += EXITO
		left_text += "Nivel %s -> Nivel %s\n" % [(knowl.currentLevel - 1), knowl.currentLevel]
	else: 
		res += FALLO
	
	left_text += "Fallos: %s" % knowl.failAttempts
	left_text += "\nMotivacion: %s" % knowl.motivation
	res += BB_left_text(left_text)
	
	content = res
	return res

## BBCode conversions
func BB_left_text(text : String) -> String:
	var res : String
	res = "[font_size=%s][right]%s[/right]" % [FONT_SIZE, text]
	return res
## Creates needed/got bbcode from variables. Adds "font_size" 10 and "right" alignment.
func BB_need_got(needed : int, got : int) -> String: 
	var res : String
	res = "[font_size=%s][right]Necesitaba: %s\nObtuvo: %s[/right]" % [FONT_SIZE, needed, got]
	return res
## Creates effect list. "font_size" 10 and "right" alignment.
func BB_effects_activated(list : Array[Effect]) -> String: 
	var res : String
	res = "[font_size=%s][right]" % [FONT_SIZE]
	for eff in list:
		res += "\n%s" % [eff.effectName]
	res += "[/right]"
	return res
