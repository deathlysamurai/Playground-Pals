extends StaticBody2D
class_name Block

@onready var sprite_2d: Sprite2D = $Sprite2D

var block_position: Vector2

func _ready() -> void:
	block_position = sprite_2d.position
