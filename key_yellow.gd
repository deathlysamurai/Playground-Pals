extends Node2D

@export var item_resource: InventoryObject

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.texture = item_resource.world_texture
