extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Checks if the player has fallen too far and resets the level
	if position.y >= 10000:
		get_tree().reload_current_scene()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
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
			$PlayerAnimation.play("idle")
		else:
			$PlayerAnimation.play("jump")

	move_and_slide()

func _process(delta: float) -> void:
	# Reload level
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
