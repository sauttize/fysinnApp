extends Control

@export var playerData : PlayerData
@export var editWindow : Window
@export var editWindowButton : Button

# NodeList
@export_category("Spell List")
@export var spellNode1 : SpellNode
@export var spellNode2 : SpellNode
@export var spellNode3 : SpellNode
@export var spellNode4 : SpellNode
var spellNodeList : Array[SpellNode]

func _ready() -> void:
	spellNodeList.append(spellNode1)
	spellNodeList.append(spellNode2)
	spellNodeList.append(spellNode3)
	spellNodeList.append(spellNode4)
	
	var cont = 0
	for sp in playerData.activeSpells:
		if sp.combat == true && cont < 4:
			spellNodeList[cont].spellData = sp
			spellNodeList[cont].update_Basics()
			cont += 1
	
	editWindowButton.button_up.connect(showWindow)
	
func showWindow():
	editWindow.popup_centered_clamped()
