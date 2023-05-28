extends Window

var spellData : Spell

# PRELOADS
var info_Elemental = preload("res://Elements/Character Sheet/Base/Spells/info_elemento.tscn")

# BUTTONS
@onready var moreInfoElement : Button = $Container/vertical/boxElement/info
@onready var activatePassive : Button = $Container/vertical/elementalEffect/activatePassive
@onready var notionLink : Button = $Container/vertical/elementalEffect/goToNotion

# LABELS
@onready var winName : Label = $Container/vertical/boxName/name
@onready var winElement : Label = $Container/vertical/boxElement/element
@onready var winType : Label = $Container/vertical/tabla/type
@onready var winLevel : Label = $Container/vertical/tabla/level
@onready var winIsCombat : Label = $Container/vertical/tabla/isCombat
@onready var winRace : Label = $Container/vertical/tabla/race
@onready var winThrow : Label = $Container/vertical/tabla/dice
@onready var winRange : Label = $Container/vertical/tabla/range
@onready var winSaveThrow : Label = $Container/vertical/tabla/saveThrow
@onready var winDescription : RichTextLabel = $Container/vertical/extraInfo
@onready var winBuff : Label = $Container/vertical/elementalEffect/buff
@onready var winDebuff : Label = $Container/vertical/elementalEffect/debuff

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
		
		if (spellData.spellType): 
			var typesString : Array[String] = spellData.getTypesAsString()
			winType.text = ""
			for n in typesString.size():
				winType.text += typesString[n].to_pascal_case()
				if (n != typesString.size() - 1): winType.text += ", "
		
		winLevel.text = str(spellData.level)
		
		if (spellData.combat): winIsCombat.text = "Utilizable"
		else: winIsCombat.text = "No utilizable"
		
		
		if (spellData.races): 
			var racesString : Array[String] = spellData.getRacesAsString()
			winRace.text = ""
			for n in racesString.size():
				winRace.text += racesString[n].to_pascal_case()
				if (n != racesString.size() - 1): winRace.text += ", "
		
		winThrow.text = spellData.throwMultiplier + spellData.throwDice
		winRange.text = str(spellData.rangeDistance)
		if (!spellData.saveThrow == "none"):
			winSaveThrow.text = spellData.saveThrow
		winDescription.text = spellData.description

func goToLink():
	spellData.goToLink()

func showElementInfo():
	var instance = info_Elemental.instantiate()
	add_child(instance)
	var instanceNode = get_node("Info Elemento")
	instanceNode.popup_centered_clamped()
	instanceNode.readElement(spellData.element)
