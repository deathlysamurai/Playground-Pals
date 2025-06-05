extends HBoxContainer

@export var number_texture: NumberTextures

@onready var item_texture: TextureRect = $ItemTexture
@onready var count_container: HBoxContainer = $CountContainer
@onready var count_texture: TextureRect = $CountContainer/CountTexture


func update_item_display(item: InventoryObject, current_inventory: Dictionary):
	item_texture.texture = current_inventory[item.id]["resource"].hud_texture
	var count = current_inventory[item.id]["quantity"]
	update_count(count)


func update_count(count: int): 
	count = min(count, 9) # Maximum of 9 until/unless handling 10s places, etc, is introduced
	if count > 1:
		toggle_counter(true)
		count_texture.texture = number_texture.numbers[count]
	else:
		toggle_counter(false)


func toggle_counter(enabled: bool):
	count_container.visible = enabled
