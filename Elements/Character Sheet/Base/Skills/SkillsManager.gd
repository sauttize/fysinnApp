extends Control

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@export_category("Nodes")
@export_subgroup("Stats")
@export var fue_num : LineEdit
@export var des_num : LineEdit
@export var con_num : LineEdit
@export var int_num : LineEdit
@export var sab_num : LineEdit
@export var car_num : LineEdit
@export_subgroup("MOD")
@export var fue_MOD : SpinBox
@export var des_MOD : SpinBox
@export var con_MOD : SpinBox
@export var int_MOD : SpinBox
@export var sab_MOD : SpinBox
@export var car_MOD : SpinBox

var fue : int
var des : int
var con : int
var inte : int
var sab : int
var car : int

signal updateMaxLife

func _ready():
	set_localStats_fromFile()
	set_lineEdit_fromLocalVar()
	update_modifiers()
	
	fue_num.text_changed.connect(stat_changed)
	des_num.text_changed.connect(stat_changed)
	con_num.text_changed.connect(stat_changed)
	int_num.text_changed.connect(stat_changed)
	sab_num.text_changed.connect(stat_changed)
	car_num.text_changed.connect(stat_changed)
	
func set_localStats_fromFile():
	fue = playerData.stats.strength
	des = playerData.stats.dexterity
	con = playerData.stats.constitution
	inte = playerData.stats.intelligence
	sab = playerData.stats.wisdom
	car = playerData.stats.charisma

func set_lineEdit_fromLocalVar():
	fue_num.text = str(fue)
	des_num.text = str(des)
	con_num.text = str(con)
	int_num.text = str(inte)
	sab_num.text = str(sab)
	car_num.text = str(car)

func set_fileStats_fromLineEdit():
	playerData.stats.strength = int(fue_num.text)
	playerData.stats.dexterity = int(des_num.text)
	playerData.stats.constitution = int(con_num.text)
	playerData.stats.intelligence = int(int_num.text)
	playerData.stats.wisdom = int(sab_num.text)
	playerData.stats.charisma = int(car_num.text)

func update_modifiers():
	fue_MOD.value = playerData.stats.stat_to_mod(fue)
	des_MOD.value = playerData.stats.stat_to_mod(des)
	con_MOD.value = playerData.stats.stat_to_mod(con)
	int_MOD.value = playerData.stats.stat_to_mod(inte)
	sab_MOD.value = playerData.stats.stat_to_mod(sab)
	car_MOD.value = playerData.stats.stat_to_mod(car)

func set_localMOD_toFile():
	playerData.stats.strengthMOD = int(fue_MOD.value)
	playerData.stats.dexterityMOD = int(des_MOD.value)
	playerData.stats.constitutionMOD = int(con_MOD.value)
	playerData.stats.intelligenceMOD = int(int_MOD.value)
	playerData.stats.wisdomMOD = int(sab_MOD.value)
	playerData.stats.charismaMOD = int(car_MOD.value)

#Stats chage signals
func stat_changed(text : String):
	if (int(text)):
		set_fileStats_fromLineEdit()
		set_localStats_fromFile()
		update_modifiers()
		set_localMOD_toFile()
		
		updateMaxLife.emit()
