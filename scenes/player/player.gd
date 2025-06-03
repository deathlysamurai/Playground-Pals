extends CharacterBody2D


const SPEED = 300.0
const SPRINT_FACTOR = 1.5
const JUMP_VELOCITY = -400.0
const POWER_JUMP_FACTOR = 1.25
const JUMP_COUNT = 2

var cur_jump_count = 0
var is_crouching = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		cur_jump_count = 0

	# Checks if the player has fallen too far and resets the level
	if position.y >= 10000:
		get_tree().reload_current_scene()

	if Input.is_action_pressed("Crouch") and is_on_floor():
		is_crouching = true
		$PlayerAnimation.play("crouch")
	else:
		is_crouching = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var cur_jump_velocity = JUMP_VELOCITY
		if is_crouching:
			cur_jump_velocity *= POWER_JUMP_FACTOR
		velocity.y = cur_jump_velocity
		cur_jump_count += 1
	elif Input.is_action_just_pressed("ui_accept") and cur_jump_count < JUMP_COUNT:
		velocity.y = JUMP_VELOCITY
		cur_jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if not direction:
		direction = Input.get_axis("Move Left", "Move Right")
	var is_sprinting = Input.is_action_pressed("Sprint")
	if direction:
		var cur_speed = SPEED
		if is_sprinting:
			cur_speed *= SPRINT_FACTOR
		velocity.x = direction * cur_speed
		if is_on_floor():
			$PlayerAnimation.play("move")
		else:
			$PlayerAnimation.play("jump")
		if direction < 0:
			$PlayerAnimation.flip_h = 1
		else:
			$PlayerAnimation.flip_h = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			if not is_crouching:
				$PlayerAnimation.play("idle")
		else:
			$PlayerAnimation.play("jump")

	move_and_slide()

func _process(delta: float) -> void:
	# Reload level
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
