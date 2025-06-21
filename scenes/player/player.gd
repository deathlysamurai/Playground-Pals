extends CharacterBody2D
class_name Player

#region Variables
const SPEED := 300.0
const SPRINT_FACTOR := 1.5
const JUMP_VELOCITY := -500.0
const POWER_JUMP_FACTOR := 1.25

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var player_animation: AnimatedSprite2D = %PlayerAnimation

var default_gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_jump_count := 0
var max_jump_count := 2
var power_jump_ready := false
var move_direction_x := 0.0
var is_crouching := false #TODO: Check if needed as states are implemented.
var is_stunned := false

# Inputs
var input_left := false
var input_right := false
var input_down := false
var input_up := false
var input_jump := false
var input_jump_just_pressed := false
#endregion


func _ready() -> void:
	health_component.health_changed.connect(on_health_change)
	health_component.died.connect(on_died)
	health_component.vulnerable.connect(on_vulnerable)
	hurtbox_component.hurtbox_triggered.connect(on_hurtbox_triggered)
	hitbox_component.successful_hit.connect(on_successful_hit)
	GameEvents.emit_player_health_setup(health_component)
	
	state_machine.init(self, player_animation)
	
	hitbox_component.disable()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
		#hitbox_component.enable()
	#else:
		#hitbox_component.disable()
		#current_jump_count = 0
	#
	## Checks if the player has fallen too far and resets the level
	#if position.y >= 10000:
		#get_tree().reload_current_scene()
	#
	#if is_stunned:
		#move_and_slide()
		#return
	#
	#if  is_on_floor() and (Input.is_action_pressed("crouch") || Input.is_action_pressed("move_down")):
		#is_crouching = true
		#player_animation.play("crouch")
	#else:
		#is_crouching = false

	# Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#var cur_jump_velocity = JUMP_VELOCITY
		#if is_crouching:
			#cur_jump_velocity *= POWER_JUMP_FACTOR
			#%PowerJumpAudio.play()
		#else:
			#%JumpAudio.play()
		#velocity.y = cur_jump_velocity
		#current_jump_count += 1
	#elif Input.is_action_just_pressed("jump") and current_jump_count < max_jump_count:
		#velocity.y = JUMP_VELOCITY
		#current_jump_count += 1
		#%JumpAudio.play()

	# Get the input direction and handle the movement/deceleration.
	#var direction := Input.get_axis("move_left", "move_right")
	#var is_sprinting = Input.is_action_pressed("sprint")
	#if direction:
		#var current_speed = SPEED
		#if is_sprinting:
			#current_speed *= SPRINT_FACTOR
		#velocity.x = direction * current_speed
		#if is_on_floor():
			#player_animation.play("move")
		#else:
			#player_animation.play("jump")
		#flip_direction()
	#else:
		#velocity.x = lerpf(velocity.x, 0.0, (1 - exp(-10 * delta)))
		#if is_on_floor():
			#if not is_crouching:
				#player_animation.play("idle")
		#else:
			#player_animation.play("jump")
	get_input_states()
	flip_direction()
	move_and_slide()


func get_input_states() -> void:
	input_left = Input.is_action_pressed("move_left")
	input_right = Input.is_action_pressed("move_right")
	input_down = Input.is_action_pressed("move_down")
	input_up = Input.is_action_pressed("move_up")
	input_jump = Input.is_action_pressed("jump")
	input_jump_just_pressed = Input.is_action_just_pressed("jump")


func apply_gravity(delta: float, gravity: float = default_gravity) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		current_jump_count = 0


func handle_falling() -> void:
	# See if player is falling, such as getting bumped or walked off a ledge.
	if !is_on_floor():
		state_machine.change_state("fall")


func handle_landing() -> void:
	if is_on_floor():
		state_machine.change_state("idle")


func handle_horizontal_movement(delta: float) -> void:
	move_direction_x = Input.get_axis("move_left", "move_right")
	if move_direction_x!= 0:
		velocity.x = move_direction_x * SPEED
	else:
		velocity.x = lerpf(velocity.x, 0.0, (1 - exp(-10 * delta)))


func handle_jump(high_jump: bool = false) -> void:
	if input_jump_just_pressed and current_jump_count < max_jump_count:
		power_jump_ready = high_jump
		state_machine.change_state("jump")
		current_jump_count += 1
		#velocity.y = (JUMP_VELOCITY * POWER_JUMP_FACTOR) if power_jump_ready else JUMP_VELOCITY


func flip_direction() -> void:
	# Change visuals left/right orientation
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(move_sign, 1)


## [param direction] is from a hurtbox to a hitbox, [param toward_direction]
## indicates if the bounce should be in the same direction or opposite. 
## [code]true[/code] if player should move in line with the direction.
func bounce_from_hit(direction: Vector2, toward_direction: bool):
	var move_sign := 1.0
	if !toward_direction:
		move_sign = -1
	velocity = move_sign * direction.normalized() * -JUMP_VELOCITY/1.5


#region Signal Handling
## This would be a decent location to add any effects to the player when their health is changed.
func on_health_change(damage: int):
	if damage > 0:
		player_animation.play("hurt")
		is_stunned = true
	GameEvents.emit_player_health_changed()


## Place to add any death animations/sounds/events
func on_died():
	GameEvents.emit_game_over(false)


func on_vulnerable():
	is_stunned = false


func on_hurtbox_triggered(direction: Vector2):
	bounce_from_hit(direction, false)
	%HurtAudio.play()


func on_successful_hit(direction: Vector2):
	bounce_from_hit(direction, true)
	%HitAudio.play()

#endregion
