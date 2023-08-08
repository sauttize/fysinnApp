extends Panel
class_name InventoryManager

@onready var playerData : PlayerData = GameManager.GetCurrentSaveFile()

var current_item : Item = null
@export var item_list : VBoxContainer
@export var item_slot : PackedScene
@export_subgroup("Item information")
@export var item_photo : TextureRect
@export var item_data : RichTextLabel
@export var price_num : SpinBox
@export var price_sent_delay : float = 0.3
@export var activate_bttn : Button

func _ready() -> void:
	update_list()
	
	price_num.value_changed.connect(update_price)
	activate_bttn.pressed.connect(activate_effect)
	
	get_tree().get_root().files_dropped.connect(file_dropped)

func update_list() -> void:
	clear_list()
	clear_information()
	for item in playerData.item_list:
		var new_slot = item_slot.instantiate() as ItemSlotButton
		new_slot.item_attached = item
		item_list.add_child(new_slot)
		new_slot.update_name()
		
		new_slot.item_selected.connect(get_item_info)

func clear_list() -> void:
	if item_list.get_children().size() == 0: return
	for node in item_list.get_children():
		node.queue_free()

func clear_information() -> void:
	item_data.clear()
	item_data.append_text("[b]Nombre:[/b] -\n[b]Tipo[/b]: -\n\n[b]Descripcion:[/b] -\n[b]Peso:[/b] -")
	activate_bttn.hide()

func get_item_info(item_selected : Item) -> void:
	current_item = item_selected
	if current_item:
		if current_item.image: item_photo.texture = current_item.image
		else: item_photo.texture = null
		item_data.clear()
		item_data.append_text("[b]Nombre:[/b] %s" % [current_item.itemName])
		item_data.newline()
		item_data.append_text("[b]Tipo[/b]: %s" % [current_item.type])
		item_data.newline()
		if current_item.isConsumable: 
			activate_bttn.show()
			item_data.append_text("[b]Usos[/b]: %s" % [str(current_item.uses_cant)])
			item_data.newline()
		else:
			activate_bttn.hide()
		item_data.newline()
		item_data.append_text("[b]Descripcion:[/b] %s" % [current_item.description])
		item_data.newline()
		item_data.append_text("[b]Peso:[/b] %s kg" % [current_item.weight])
		price_num.value = current_item.price

func update_price(new_price : int) -> void:
	await get_tree().create_timer(price_sent_delay).timeout
	if current_item:
		current_item.price = int(new_price)

func activate_effect() -> void:
	if current_item.isConsumable && current_item.effect.size() != 0:
		if current_item.uses_cant == 1:
			for eff in current_item.effect:
				playerData.activeEffects.append(eff)
			playerData.item_list.erase(current_item)
			Utilities.create_PopUp("Item ha sido eliminado al terminar sus posibles usos.")
			clear_information()
			current_item = null
			update_list()
		elif current_item.uses_cant > 1:
			for eff in current_item.effect:
				playerData.activeEffects.append(eff)
			current_item.uses_cant -= 1
			Utilities.create_PopUp("Has usado una vez el objeto. Aun tienes %s usos más." % [current_item.uses_cant])
			get_item_info(current_item)
		else:
			Utilities.create_PopUp("Lo siento, ha ocurrido un error.")

func file_dropped(files_path : PackedStringArray) -> void:
	if is_visible_in_tree() != true: return # If it's outside inventory tab
	await get_tree().create_timer(0.2).timeout
	
	if files_path.size() == 1:
		var err = Image.new().load(files_path[0])
		if err == OK:
			var new_img = Image.load_from_file(files_path[0])
			var new_text = ImageTexture.create_from_image(new_img)
			if current_item:
				current_item.image = new_text
				item_photo.texture = current_item.image
				return
			else:
				Utilities.create_PopUp("No hay item seleccionado...")
				return
	
	for n in files_path.size():
		var file = ResourceLoader.load(files_path[n])
		if file && file is Item:
			playerData.item_list.append(file)
			update_list()
		else:
			Utilities.create_PopUp("Solo puedes agregar recursos del tipo item.\n Para agregar imagen recuerda soltar una sola.")

