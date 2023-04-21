extends Control

@export var _playerData : PlayerData
@export_category("Skills numbers")
@export var fue_num : LineEdit
@export var des_num : LineEdit
@export var con_num : LineEdit
@export var int_num : LineEdit
@export var sab_num : LineEdit
@export var car_num : LineEdit

var fue : int
var des : int
var con : int
var inte : int
var sab : int
var car : int

signal updateBonuses(fue:int, des:int, con:int, inte:int, sab:int, car:int)

func _ready():
	update_data(_playerData)

func update_data(playerData : PlayerData):
	fue = playerData.skills[0]
	des = playerData.skills[1]
	con = playerData.skills[2]
	inte = playerData.skills[3]
	sab = playerData.skills[4]
	car = playerData.skills[5]
	
	fue_num.text = str(fue)
	des_num.text = str(des)
	con_num.text = str(con)
	int_num.text = str(inte)
	sab_num.text = str(sab)
	car_num.text = str(car)
	
	updateBonuses.emit(fue, des, con, inte, sab, car)

#Updates data when new file is loaded.
func _on_base_update_base_data(data):
	update_data(data)

func reloadData():
	GameManager.save_and_reload()

#Bonus calculator
func do_math(number : int):
	match number:
			1:
				return (-5)
			2, 3:
				return (-4)
			4,5:
				return (-3)
			6,7:
				return (-2)
			8,9:
				return (-1)
			10,11:
				return 0
			12,13:
				return 1
			14,15:
				return 2
			16,17:
				return 3
			18, 19:
				return 4
			20, 21:
				return 5
			22,23:
				return 6
			24,25:
				return 7
			26,27:
				return 8
			28,29:
				return 9
			30:
				return 10
			_:
				return 0

#Update FUE
func _on_fue_bonus_update_skill(node, number):
	node.value = do_math(number)
	_playerData.modifiers[0] = do_math(number)
	_playerData.skills[0] = number
#Update DES
func _on_des_bonus_update_des(node, number):
	node.value = do_math(number)
	_playerData.modifiers[1] = do_math(number)
	_playerData.skills[1] = number
#Update CON
func _on_con_bonus_update_con(node, number):
	node.value = do_math(number)
	_playerData.modifiers[2] = do_math(number)
	_playerData.skills[2] = number
#Update INT
func _on_int_bonus_update_int(node, number):
	node.value = do_math(number)
	_playerData.modifiers[3] = do_math(number)
	_playerData.skills[3] = number
#Update SAB
func _on_sab_bonus_update_sab(node, number):
	node.value = do_math(number)
	_playerData.modifiers[4] = do_math(number)
	_playerData.skills[4] = number
#Update CAR
func _on_car_bonus_update_car(node, number):
	node.value = do_math(number)
	_playerData.modifiers[5] = do_math(number)
	_playerData.skills[5] = number
