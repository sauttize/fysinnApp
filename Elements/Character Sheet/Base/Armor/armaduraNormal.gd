extends Label

func _ready():
	text = "0"


func _add_armor(add : int):
	var textToNum = int(text)
	textToNum += add
	text = str(textToNum)
	
func _update_armor(newArmor : int):
	text = str(newArmor)

# Sets save values
func _on_base_update_base_data(_data):
	#ARMOR IN PROGRESS
	pass
