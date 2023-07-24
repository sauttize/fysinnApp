extends Window
class_name SpellInfoWindow

var spellData : Spell

# PRELOADS AND OTHER
var info_Elemental = preload("res://Elements/Character Sheet/Base/Spells/info_elemento.tscn")

# BUTTONS
@export_subgroup("Buttons")
@export var moreInfoElement : Button
@export var activateEffect : Button
@export var notionLink : Button

# LABELS
@export_subgroup("Labels")
@export var winName : Label
@export var winElement : Label
@export var winType : Label
@export var winLevel : Label
@export var winIsCombat : Label
@export var winRace : Label
@export var winThrow : Label
@export var winRange : Label
@export var winSaveThrow : Label
@export var winDescription : RichTextLabel
@export var winBuff : Label
@export var winDebuff : Label

func _ready() -> void:
	#buttons set up
	moreInfoElement.button_up.connect(showElementInfo)
	notionLink.button_up.connect(goToLink)

func update_Complete(data : Spell):
	spellData = data
	if (!spellData): return
	
	winName.text = spellData.spellName # Name
	if (spellData.isElemental && spellData.element): # Element, buff and debuff
		winElement.text = spellData.element.getString()
		winBuff.text = spellData.buffMuliplier + spellData.buffElementalDice
		winDebuff.text = spellData.debuffMuliplier + spellData.debuffElementalDice
	
	if (spellData.spellType): # Type
		var typesString : Array[String] = spellData.getTypesAsString()
		winType.text = ""
		for n in typesString.size():
			winType.text += typesString[n].to_pascal_case()
			if (n != typesString.size() - 1): winType.text += ", "
	
	winLevel.text = str(spellData.level) # Level
	
	# For combat or not
	if (spellData.combat): winIsCombat.text = "Utilizable"
	else: winIsCombat.text = "No utilizable"
	
	if (spellData.races): # Races
		var racesString : Array[String] = spellData.getRacesAsString()
		winRace.text = ""
		if racesString.has("All"):
			winRace.text = "Todas"
		else:
			for n in racesString.size():
				winRace.text += racesString[n].to_pascal_case()
				if (n != racesString.size() - 1): winRace.text += ", "
	
	# Win, save throw & Range
	winThrow.text = spellData.throwMultiplier + spellData.throwDice
	winRange.text = str(spellData.rangeDistance)
	if (!spellData.saveThrow == "none"):
		winSaveThrow.text = spellData.saveThrow
	winDescription.text = spellData.description
	
	
	if spellData.effects.size() == 0:
		activateEffect.disabled = true
	else:
		activateEffect.disabled = false
		activateEffect.pressed.connect(activate_effect)

func activate_effect():
	if spellData.effects.size() != 0 && spellData.effects is Array[Effect]:
		var playerData = GameManager.GetCurrentSaveFile() as PlayerData
		for eff in spellData.effects:
			playerData.activeEffects.append(eff)
		GameManager.UpdateOriginalSaveFile()
		get_tree().reload_current_scene()

func goToLink():
	spellData.goToLink()

func showElementInfo():
	var instance = info_Elemental.instantiate()
	add_child(instance)
	var instanceNode = get_node("Info Elemento")
	instanceNode.popup_centered_clamped()
	instanceNode.readElement(spellData.element)
