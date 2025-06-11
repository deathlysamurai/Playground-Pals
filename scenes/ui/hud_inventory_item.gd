extends HBoxContainer

@export var number_texture: NumberTextures

@onready var item_texture: TextureRect = $ItemTexture
@onready var count_container: HBoxContainer = $CountContainer
@onready var ones_count_texture: TextureRect = %OnesCountTexture
@onready var tens_count_texture: TextureRect = %TensCountTexture


func update_item_display(item: InventoryObject, current_inventory: Dictionary):
	item_texture.texture = current_inventory[item.id]["resource"].hud_texture
	var count = current_inventory[item.id]["quantity"]
	update_count(count)


## Updates the number textures. No multiplier if the count is only 1.
## Starts as a single digit, adds second digit only at 10-99. Cap of 99.
func update_count(count: int): 
	count = min(count, 99)
	if count > 9:
		toggle_counter(true)
		tens_count_texture.texture = number_texture.numbers[count / 10]
		ones_count_texture.texture = number_texture.numbers[count % 10]
		tens_count_texture.visible = true
	elif count > 1:
		toggle_counter(true)
		ones_count_texture.texture = number_texture.numbers[count]
		tens_count_texture.visible = false
	else:
		toggle_counter(false)


func toggle_counter(enabled: bool):
	count_container.visible = enabled
