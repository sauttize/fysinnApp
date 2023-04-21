extends Label

@export var _playerData : PlayerData

func _checkData():
	text = str(_playerData.currentLife)

func _add_lifepoints(value : int):
	var textToInt = int(text)
	textToInt += value
	# If life is greater than max life with con stat.
	if (textToInt > (_playerData.maxLife + _playerData.modifiers[2])): 
		_playerData.currentLife =  _playerData.maxLife + _playerData.modifiers[2]
	else:
		_playerData.currentLife = textToInt
	_checkData()

func _sub_lifepoints(value : int):
	var textToInt = int(text)
	textToInt -= value
	_playerData.currentLife = textToInt
	_checkData()

func _update_lifepoints(value : int):
	if (int(value)): 
		_playerData.currentLife = value
		_checkData()

#Sets points in save file
func _on_base_update_base_data(data):
	#_update_lifepoints(data.currentLife)
	_checkData()

#Adds
func _on_edit_life_add_current(value):
	_add_lifepoints(value)
#Subs
func _on_edit_life_sub_current(value):
	_sub_lifepoints(value)
	# LUEGO HACER CHECK DE MUERTE
