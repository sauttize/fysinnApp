extends Panel

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@export_category("Figure Texture")
@export var current_ind : int = 0
@export var silueta_img : TextureRect
@export var siluetas_textures : Array[Texture2D]
@export var back_bttn : Button
@export var foward_bttn : Button
@export_category("Armor Pieces")
@export var slot_scene : PackedScene
@export var grid_container : GridContainer

func _ready() -> void:
	current_ind = playerData.body_type
	change_figure(0)
	
	back_bttn.pressed.connect(change_figure.bind(-1))
	foward_bttn.pressed.connect(change_figure.bind(1))
	
	clear_list()
	fill_list()
	
func change_figure(add : int):
	current_ind += add
	if current_ind < 0: current_ind = 6
	elif current_ind > 6: current_ind = 0
	playerData.body_type = current_ind
	silueta_img.texture = siluetas_textures[current_ind]

## List of pieces
func clean_update() -> void:
	clear_list()
	fill_list()

func clear_list() -> void:
#	if grid_container.get_children().size() == 0: return
	for slot in grid_container.get_children():
		slot.queue_free()

func fill_list() -> void:
	for piece in playerData.armor_pieces:
		var newSlot = slot_scene.instantiate() as ArmorSlot
		newSlot.current_piece = piece
		newSlot.full_update(true)
		grid_container.add_child(newSlot)
