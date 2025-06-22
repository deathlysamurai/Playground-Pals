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
	hurtbox_component.hurtbox_triggered.connect(on_hurtbox_triggered)
	hitbox_component.successful_hit.connect(on_successful_hit)
	GameEvents.emit_player_health_setup(health_component)
	
	state_machine.init(self, player_animation)
	
	hitbox_component.disable()


func _physics_process(delta: float) -> void:
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


func flip_direction() -> void:
	# Change visuals left/right orientation
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(move_sign, 1)


## [param direction] is from a hurtbox to a hitbox, [param toward_direction]
## indicates if the bounce should be in the same direction or opposite. 
## [code]true[/code] if player should move in line with the direction.
func bounce_from_collision(direction: Vector2, toward_direction: bool):
	var move_sign := 1.0
	if !toward_direction:
		move_sign = -1
	velocity = move_sign * direction.normalized() * 400


#region Signal Handling
## This would be a decent location to add any effects to the player when their health is changed.
func on_health_change(damage: int):
	if damage > 0:
		state_machine.change_state("stun")
	GameEvents.emit_player_health_changed()


## Place to add any death animations/sounds/events
func on_died():
	GameEvents.emit_game_over(false)


func on_hurtbox_triggered(direction: Vector2):
	bounce_from_collision(direction, false)
	%HurtAudio.play()


func on_successful_hit(direction: Vector2):
	bounce_from_collision(direction, true)
	%HitAudio.play()

#endregion
