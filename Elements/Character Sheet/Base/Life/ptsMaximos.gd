extends Label

@export var _playerData : PlayerData

func _checkData():
	text = str(_playerData.maxLife + _playerData.modifiers[2])

func _add_maxlife(value : int):
	#var textToInt = int(text)
	#textToInt += value
	_playerData.maxLife += value 
	_checkData()

func _update_maxlife(value : int):
	if (int(value)): text = str(value)
	
#Sets max life from save file
func _on_base_update_base_data(_data):
	#_update_maxlife(data.maxLife)
	_checkData()

func _on_edit_life_update_max(value):
	_add_maxlife(value)
