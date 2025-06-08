extends Area2D
class_name HitboxComponent
## Provides a damage integer and an [Area2D] for collision checks

@export var damage: int = 0
@export var _collision_shape: CollisionShape2D

var _disabled = func(disabled: bool): _collision_shape.disabled = disabled

func _ready() -> void:
	if _collision_shape == null:
		print(owner.name + "'s HitboxComponent is missing it's collision shape")


## Returns [param true] if the collision shape for this HitboxComponent is disabled.
func get_collision_disabled():
	return _collision_shape.disabled


## Enables this component's [param CollisionShape2D] at the end of the frame.
func enable():
	_disabled.call_deferred(false)


## Disables this component's [param CollisionShape2D] at the end of the frame.
func disable():
	_disabled.call_deferred(true)
