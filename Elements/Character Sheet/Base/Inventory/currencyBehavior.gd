extends Button

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()
@onready var variablesDic : Dictionary = {
	"PC": playerData.pc, "PP" : playerData.pp, "PE" : playerData.pe, 
	"PO" : playerData.po, "PPT" : playerData.ppt
}

@export_subgroup("Labels")
@export var pc_label : RichTextLabel
@export var pp_label : RichTextLabel
@export var pe_label : RichTextLabel
@export var po_label : RichTextLabel
@export var ppt_label : RichTextLabel
@export_subgroup("Edit Window Elements")
@export var editWindow : Window
@export var numberNode : SpinBox
var currentNumber : int = 0
@export_subgroup("Edit Window Elements/Add or Delete")
@export var addOption : OptionButton
@export var addButton : Button
@export_subgroup("Edit Window Elements/Change")
@export var fromOp : OptionButton
@export var toOp: OptionButton
@export var changeButton : Button


func _ready() -> void:
	update_data()
	
	pressed.connect(editWindow.show)
	editWindow.close_requested.connect(editWindow.hide)
	
	addButton.pressed.connect(add_number)
	changeButton.pressed.connect(change_currency)

func update_data():
	playerData.pc = variablesDic["PC"]
	playerData.pp = variablesDic["PP"]
	playerData.pe = variablesDic["PE"]
	playerData.po = variablesDic["PO"]
	playerData.ppt = variablesDic["PPT"]
	
	pc_label.text = "[b]PC: [/b]" + str(playerData.pc)
	pp_label.text = "[b]PP: [/b]" + str(playerData.pp)
	pe_label.text = "[b]PE: [/b]" + str(playerData.pe)
	po_label.text = "[b]PO: [/b]" + str(playerData.po)
	ppt_label.text = "[b]PPT: [/b]" + str(playerData.ppt)

func check_number(noNegative : bool = false, showMessage : bool = false) -> bool:
	# noNegative means it doesn't allow negative numbers.
	if (!noNegative && numberNode.value != 0): return true
	elif (noNegative && numberNode.value > 0): return true 
	else: 
		if showMessage: Utilities.create_PopUp("El valor no puede ser 0.")
		return false

func add_number():
	if check_number(false, true):
		currentNumber = numberNode.value
		var from_str : String = addOption.get_item_text(addOption.selected)
		var old_value = variablesDic[from_str]
		variablesDic[from_str] = variablesDic[from_str] + currentNumber
		Utilities.create_PopUp("Has modificado tus %s. Resultado: %s (%s +(%s))." % 
		[from_str, variablesDic[from_str], old_value, currentNumber])
		update_data()
		editWindow.hide()

func change_currency():
	currentNumber = numberNode.value
	var from_str = fromOp.get_item_text(fromOp.selected)
	var to_str = toOp.get_item_text(toOp.selected)
	
	print(numberNode.value)
	if check_number(true): 
		var moneyNeeded = GameManager.money_needed(currentNumber, from_str, to_str)
		
		if variablesDic[from_str] < moneyNeeded:
			Utilities.create_PopUp("No tienes cantidad suficiente de " + from_str)
		else:
			variablesDic[from_str] = variablesDic[from_str] - moneyNeeded
			variablesDic[to_str] = variablesDic[to_str] + currentNumber
			update_data()
			Utilities.create_PopUp("Has pasado %s de %s a %s de %s." % 
			[moneyNeeded, from_str, currentNumber, to_str])
	else:
		Utilities.create_PopUp("Negativos no se permiten para el cambio.")
