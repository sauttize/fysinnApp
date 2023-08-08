extends HBoxContainer
@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

# Variables
enum STRIKE_TYPE {GOOD, BAD}

@export var strikeType : STRIKE_TYPE = STRIKE_TYPE.GOOD
@export var modulateColor : Color
var allStrikes : Array[Node]

@onready var nostr_normal_texture = preload("res://_assets/Icons/Death Strikes/no strike.png")
@onready var nostr_hover_texture = preload("res://_assets/Icons/Death Strikes/no strike/no strike hover.png")
@onready var nostr_pressed_texture = preload("res://_assets/Icons/Death Strikes/no strike/no strike pressed.png")
@onready var str_normal_texture = preload("res://_assets/Icons/Death Strikes/strike.png")
@onready var str_hover_texture = preload("res://_assets/Icons/Death Strikes/strike/strike hover.png")
@onready var str_pressed_texture = preload("res://_assets/Icons/Death Strikes/strike/strike pressed.png")

# Methods
func _ready() -> void:
	var cont : int = 0
	for node in get_children():
		cont = cont + 1
		allStrikes.push_back(node)
		node.pressed.connect(on_button_pressed.bind(cont))
	update_by_savefile()

func on_button_pressed(strikeNumber : int = 0):
	match strikeType:
		STRIKE_TYPE.GOOD:
			if strikeNumber != playerData.goodStrike:
				playerData.goodStrike = strikeNumber
			elif strikeNumber == playerData.goodStrike:
				playerData.goodStrike = strikeNumber - 1
		STRIKE_TYPE.BAD:
			if strikeNumber != playerData.badStrike:
				playerData.badStrike = strikeNumber
			elif strikeNumber == playerData.badStrike:
				playerData.badStrike = strikeNumber - 1
	update_by_savefile()

func update_by_savefile():
	var strikeCounter : int = playerData.goodStrike if strikeType == STRIKE_TYPE.GOOD else playerData.badStrike
	for n in 3:
		var currentButton : TextureButton = allStrikes[n]
		if n + 1 <= strikeCounter:
			currentButton.texture_normal = str_normal_texture
			currentButton.texture_hover = str_hover_texture
			currentButton.texture_pressed = str_pressed_texture
			currentButton.modulate = modulateColor
		else:
			currentButton.texture_normal = nostr_normal_texture
			currentButton.texture_hover = nostr_hover_texture
			currentButton.texture_pressed = nostr_pressed_texture
			currentButton.modulate = Color.WHITE
