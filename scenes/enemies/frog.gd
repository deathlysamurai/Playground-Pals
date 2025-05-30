extends CharacterBody2D

const MAX_SPEED = 50
const JUMP_STRENGTH = 500

func _physics_process(delta: float) -> void:
	# Checks if the entity has fallen too far and removes from game
	if global_position.y >= 10000:
		queue_free()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else: # Only jump when on ground
		var direction = get_direction_to_player()
		velocity = direction * MAX_SPEED + Vector2.UP * JUMP_STRENGTH
	
	move_and_slide()

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		var direction = (player_node.global_position - global_position)
		direction.y = 0
		return direction.normalized()
	return Vector2.ZERO
