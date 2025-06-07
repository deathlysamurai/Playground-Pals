extends CharacterBody2D


const SPEED = 300.0
const SPRINT_FACTOR = 1.5
const JUMP_VELOCITY = -400.0
const POWER_JUMP_FACTOR = 1.25
const JUMP_COUNT = 2

@onready var health_component: HealthComponent = $HealthComponent

var cur_jump_count = 0
var is_crouching = false


func _ready() -> void:
	health_component.health_changed.connect(on_health_change)
	health_component.died.connect(on_died)
	GameEvents.emit_player_health_setup(health_component)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		cur_jump_count = 0

	# Checks if the player has fallen too far and resets the level
	if position.y >= 10000:
		get_tree().reload_current_scene()

	if  is_on_floor() and (Input.is_action_pressed("crouch") || Input.is_action_pressed("move_down")):
		is_crouching = true
		$PlayerAnimation.play("crouch")
	else:
		is_crouching = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		var cur_jump_velocity = JUMP_VELOCITY
		if is_crouching:
			cur_jump_velocity *= POWER_JUMP_FACTOR
		velocity.y = cur_jump_velocity
		cur_jump_count += 1
	elif Input.is_action_just_pressed("jump") and cur_jump_count < JUMP_COUNT:
		velocity.y = JUMP_VELOCITY
		cur_jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	var is_sprinting = Input.is_action_pressed("sprint")
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
		velocity.x = lerpf(velocity.x, 0.0, (1 - exp(-10 * delta)))
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


## This would be a decent location to add any effects to the player when their health is changed.
func on_health_change(component: HealthComponent):
	GameEvents.emit_player_health_changed()


## Place to add any death animations/sounds/events
func on_died(component: HealthComponent):
	GameEvents.emit_game_over(false)
