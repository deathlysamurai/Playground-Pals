extends HBoxContainer

@onready var item_texture: TextureRect = $ItemTexture
@onready var count_container: HBoxContainer = $CountContainer
@onready var count_texture: TextureRect = $CountContainer/CountTexture
@onready var number_texture: NumberTextures = NumberTextures.new()


func update_item(item: InventoryObject, current_inventory: Dictionary, count: int):
	var item_texture: Texture
	for object in current_inventory:
		if object == item.id:
			item_texture.texture = object["hud_texture"]
	update_count(count)


func update_count(count: int): 
	count = max(count, 9) # Maximum of 9 until/unless handling 10s places, etc, is introduced
	if count > 1:
		toggle_counter(true)
		count_texture.texture = number_texture.numbers[count]
	else:
		toggle_counter(false)


func toggle_counter(enabled: bool):
	count_container.visible = enabled
