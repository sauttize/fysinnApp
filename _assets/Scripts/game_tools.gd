extends Node

## Autoload script with many useful methods and tools
@onready var dataDump : DataFile = GameManager.GetDataDump()

## ----> Knowledge Tools:

enum K_TYPE {PRACTICE, BOOK, ACADEMY}

## Depending on the type of learning and the knowledge level, modifies the knowledge adding a new level
func knowledge_learn(knowl : Knowledge, type : K_TYPE, type_str : String) -> KnowledgeRecord:
	var new_record := KnowledgeRecord.new()
	
	if knowl.motivation < knowl.fail_lose:
		Utilities.create_PopUp("No tienes suficiente motivacion para intentar aprender este conocimiento.")
		new_record.create_learn_record(knowl, type_str, false)
		return new_record
	
	var level : float = float(knowl.currentLevel)
	var curve : Curve
	var success_per : float = knowl.temporaryPercentage
	var rand_num : float = randf_range(0,1)
	
	match type:
		K_TYPE.PRACTICE:
			curve = dataDump.K_CURVE_PRACTICE
			success_per += curve.sample(level / 10)
			print(level / 10)
			print(curve.sample(level / 10))
		K_TYPE.BOOK:
			curve = dataDump.K_CURVE_BOOK
			success_per += curve.sample(level / 10)
		K_TYPE.ACADEMY:
			curve = dataDump.K_CURVE_ACADEMY
			success_per += curve.sample(level / 10)
		_:
			Utilities.create_PopUp("Error with K_TYPE in %s" % self.name)
	
	print("Necesita: %s. Obtuvo: %s." % [success_per, rand_num])
	if rand_num < success_per:
		knowl.currentLevel += 1
		Utilities.create_PopUp("Exito! Ahora eres nivel %s.\nTu motivación y e intentos fallidos han sido reseteados." % knowl.currentLevel)
		new_record.create_learn_record(knowl, type_str, true)
		knowl.failAttempts = 0
		knowl.motivation = knowl.max_motivation
	else:
		Utilities.create_PopUp("Fallo...")
		knowl.failAttempts += 1
		knowl.motivation -= knowl.fail_lose
		new_record.create_learn_record(knowl, type_str, false)
	
	return new_record
	
## ----> Relationships tools:
@onready var empty_heart : Texture2D = preload("res://_assets/Icons/Heart/Relationship/empty.png")
@onready var half_heart : Texture2D = preload("res://_assets/Icons/Heart/Relationship/half_heart.png")
@onready var full_heart : Texture2D = preload("res://_assets/Icons/Heart/Relationship/full.png")

func update_heart_textures(arr : Array[TextureRect], rel : Relationship) -> void:
	var new_text_num : int = rel.full_hearts + rel.half_hearts
	var cont := 0
	for i in new_text_num:
		if cont < rel.full_hearts:
			cont += 1
			arr[i].texture = full_heart
		else:
			arr[i].texture = half_heart

func clean_heart_textures(arr : Array[TextureRect]) -> void:
	for node in arr:
		node.texture = empty_heart
