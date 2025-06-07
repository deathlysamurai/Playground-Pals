extends TextureRect

@export var empty_container: Texture
@export var half_container: Texture
@export var full_container: Texture

var heart_status: int


func set_heart_container(number: int):
	var container: Texture
	match  number:
		0:
			container = empty_container
		1:
			container = half_container
		2:
			container = full_container
		_:
			return
	texture = container
