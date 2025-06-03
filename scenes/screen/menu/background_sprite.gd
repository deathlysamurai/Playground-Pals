extends Sprite2D

func _ready() -> void:
	_on_viewport_resize()
	get_viewport().connect("size_changed", _on_viewport_resize)

func _on_viewport_resize():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y

	var scale_factor = viewportWidth / self.texture.get_size().x

	# Optional: Center the sprite, required only if the sprite's Offset>Centered checkbox is set
	self.set_position(Vector2(viewportWidth/2, viewportHeight/2))

	# Set same scale value horizontally/vertically to maintain aspect ratio
	# If however you don't want to maintain aspect ratio, simply set different
	# scale along x and y
	self.set_scale(Vector2(scale_factor, scale_factor))
