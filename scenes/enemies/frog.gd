extends CharacterBody2D

const MAX_SPEED = 100
const JUMP_STRENGTH = 500
const ACCELERATION_SMOOTHING = 20

## The base delay to the frog making a jump
@export_range(0.0, 5.0, 0.1,) var jump_delay: float = 2.0

@onready var movement_timer = $MovementTimer


func _ready() -> void:
	movement_timer.wait_time = jump_delay
	movement_timer.start()


func _physics_process(delta: float) -> void:
	# Checks if the entity has fallen too far and removes from game
	if global_position.y >= 10000:
		queue_free()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif movement_timer.is_stopped(): # Only jump when on ground and timer stopped
		var direction = get_direction_to_player()
		velocity = direction * MAX_SPEED + Vector2.UP * JUMP_STRENGTH
		movement_timer.start()
	else:
		velocity = velocity.lerp(Vector2.ZERO, (1 - exp(-ACCELERATION_SMOOTHING * delta)))
	
	move_and_slide()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		var direction = (player_node.global_position - global_position)
		direction.y = 0
		return direction.normalized()
	return Vector2.ZERO
