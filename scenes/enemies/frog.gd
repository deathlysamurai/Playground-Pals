extends CharacterBody2D

const MAX_SPEED = 120
const JUMP_STRENGTH = 500
const JUMP_STRENGTH_VARIATION = 500
const ACCELERATION_SMOOTHING = 10

## The base delay to the frog making a jump
@export_range(0.0, 5.0, 0.1,) var jump_delay: float = 2.0
## Optionally add a percentage variation. Setting 0.5 will allow a random range of -0.25 to +0.25 to the delay timing.
@export_range(0.0, 1.0, 0.1,) var jump_delay_variation: float = 0.0

@onready var movement_timer = $MovementTimer
@onready var frog_animation: AnimatedSprite2D = $Visuals/FrogAnimation
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent


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
		frog_animation.play("jump")
		velocity = direction * MAX_SPEED + Vector2.UP * JUMP_STRENGTH
		movement_timer.wait_time = jump_delay * (1 + randf_range(-jump_delay_variation/2, jump_delay_variation/2,))
		movement_timer.start()
	else:
		frog_animation.play("idle")
		velocity = velocity.lerp(Vector2.ZERO, (1 - exp(-ACCELERATION_SMOOTHING * delta)))
	
	move_and_slide()
	# Change visuals left/right orientation
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(-move_sign, 1)


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node == null:
		return Vector2.ZERO
	return (player_node.global_position - global_position).normalized()
