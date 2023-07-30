extends Panel
class_name ArmorSlot

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

@export_category("Main slots")
@export_enum("Cabeza", "Superior", "Guantes", "Inferior", "Pies", "Accesorio") var slot_type : String
@export var is_main : bool = false
@export_range(1, 3) var accesory_number : int
@onready var my_timer : Timer = $Timer
@export var armor_manager : Panel
var ready_to_drop : bool = true
@export_category("All Slots")
@export var current_piece : ArmorPiece
@onready var armor_icon : TextureRect = $Icon

func _ready() -> void:
	if current_piece:
		full_update()
	
	my_timer.timeout.connect(can_drop)

func full_update(match_type : bool = false) -> void:
	if is_main: 
		get_from_file()
		get_effect()
	if match_type: slot_type = current_piece.type
	update_visuals()
	update_tooltip()


func get_from_file() -> void:
	if playerData.armor_equipped:
		match slot_type:
			"Cabeza":
				if playerData.armor_equipped.head_piece:
					current_piece = playerData.armor_equipped.head_piece
			"Superior":
				if playerData.armor_equipped.chest_piece:
					current_piece = playerData.armor_equipped.chest_piece
			"Guantes":
				if playerData.armor_equipped.hands_piece:
					current_piece = playerData.armor_equipped.hands_piece
			"Inferior":
				if playerData.armor_equipped.legs_piece:
					current_piece = playerData.armor_equipped.legs_piece
			"Pies":
				if playerData.armor_equipped.foot_piece:
					current_piece = playerData.armor_equipped.foot_piece
			"Accesorio":
				match accesory_number:
					1:
						if playerData.armor_equipped.accesory_1:
							current_piece = playerData.armor_equipped.accesory_1
					2:
						if playerData.armor_equipped.accesory_2:
							current_piece = playerData.armor_equipped.accesory_2
					3:
						if playerData.armor_equipped.accesory_3:
							current_piece = playerData.armor_equipped.accesory_3

func set_to_file() -> void:
	if current_piece: playerData.armor_pieces.append(current_piece)
	if current_piece.effect:
		playerData.activeEffects.erase(current_piece.effect)
	if playerData.armor_equipped:
		match slot_type:
			"Cabeza":
				playerData.armor_equipped.head_piece = current_piece
			"Superior":
				playerData.armor_equipped.chest_piece = current_piece
			"Guantes":
				playerData.armor_equipped.hands_piece = current_piece
			"Inferior":
				playerData.armor_equipped.legs_piece = current_piece
			"Pies":
				playerData.armor_equipped.foot_piece = current_piece
			"Accesorio":
				match accesory_number:
					1:
						playerData.armor_equipped.accesory_1 = current_piece
					2:
						playerData.armor_equipped.accesory_2 = current_piece
					3:
						playerData.armor_equipped.accesory_3 = current_piece
		GameManager.UpdateOriginalSaveFile()

func delete_from_unequipped(piece : ArmorPiece) -> void:
	if playerData.armor_pieces.has(piece):
		playerData.armor_pieces.erase(piece)

func update_visuals() -> void:
	if current_piece:
		Utilities.changeFlatboxColor_Panel(self, current_piece.color)
		if current_piece.icon: armor_icon.texture = current_piece.icon

func update_tooltip() -> void:
	var has_effect = "Si" if current_piece.effect else "No"
	tooltip_text = "%s \n\nNombre: %s.\nValor base: %s.\nRareza: %s.\nValor extra: %s.\nEfecto: %s." % [
		slot_type , current_piece.name, current_piece.base_value, current_piece.rarity, current_piece.extra_value, has_effect
	]

func get_effect() -> void:
	if current_piece.effect:
		playerData.activeEffects.append(current_piece.effect)

# Timer
func activate_timer():
	if ready_to_drop:
		ready_to_drop = false
		my_timer.start()

func can_drop(): 
	ready_to_drop = true

# Drag and drop
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if !ready_to_drop: return false
	else: activate_timer()
	
	if data is ArmorSlot && !data.is_main:
		if data.slot_type == self.slot_type:
			return true
		else:
			Utilities.create_PopUp("Esa pieza no corresponde a este slot.")
			return false
	else:
		return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if self.is_main:
		if data.current_piece:
			var piece = data.current_piece
			self.current_piece = piece
			set_to_file()
			full_update()
			delete_from_unequipped(piece) # Avoids duplicate
			data.queue_free()
			Utilities.create_PopUp("¡Equipado! (y partida guardada)")
			armor_manager.clean_update()
		else: print("error in dropping data")

func _get_drag_data(_at_position: Vector2) -> Variant:
	if !is_main:
		var control_ghost : ArmorSlot = self.duplicate()
		set_drag_preview(control_ghost)
		return self
	else:
		return null
