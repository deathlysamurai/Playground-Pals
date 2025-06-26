extends State
class_name EnemyChase
# TODO: Some of this class should be refactored into inherited classes, such as the jump and float.
# That's partly why I broke the move direction out into separate functions, to be overridden.
# Could also make it so you can pass delta into those functions to apply an acceleration.

# The minimum height of the normalized direction vector for jump_strength to be applied
const JUMP_MINIMUM_Y_VECTOR := -0.25

## State to use when player is beyond [param max_distance].
@export var stop_chase_state: State
## State to use after [param duration] has passed.
@export var timeout_state: State
## How fast the enemy should move horizontally.
@export var move_speed: float = 50.0
## Strength of vertical components. Zero (0) means there's only horizontal speed.
@export var jump_strength: float = 0.0
## The distance from player where the enemy stops exits this state.
@export var max_distance: float = 64 * 8 # 64px per tile, 8 tiles away
## Duration of a timer that will end the chase. 0 for endless.
@export var duration: float = 0
## Does the enemy move toward the player ([param On] / [code]true[/code]) [br]
## Or away from the player ([param Off] / [code]false[/code])
@export var toward_player: bool = true
## Determines how jump strength is applied to the movement direction.
@export_enum("Walk", "Jump", "Float") var movement_type: String = "Walk"
## Time in between jumps. The time is between jumping actions, not landing.
@export_range(0, 3, .1) var move_delay: float = 0
## The [param String] name of the animation to play when jumping.
@export var jump_animation_name: String


var player: CharacterBody2D
var velocity: Vector2
var direction: Vector2
var move_sign: float = 1.0
var use_timer: bool = false
var time_remaining: float
var move_delay_remaining: float = 0


func enter():
	super()
	player = get_tree().get_first_node_in_group("player")
	move_delay_remaining = move_delay
	if duration > 0:
		time_remaining = duration
		use_timer = true
	if jump_animation_name == null:
		jump_animation_name = animation_name


func physics_update(delta: float):
	direction = player.global_position - parent.global_position
	animate_movement()
	# Exit state checks. Timer, falling, and distance from player.
	if end_chase(delta):
		return
	
	if move_delay_remaining > 0:
		move_delay_remaining -= delta
		decelerate(delta)
		return
	move_delay_remaining = move_delay
	
	velocity = parent.velocity
	direction = direction.normalized()
	move_sign = 1.0 if toward_player else -1.0
	
	# Assign a magnitude to velocity vector
	move_vertical()
	move_horizontal()
	parent.velocity = velocity


func end_chase(delta: float) -> bool:
	if timer_countdown(delta):
		return true
	if check_distance():
		return true
	if is_airborne(delta):
		return true	
	return false


func timer_countdown(delta: float) -> bool:
	if use_timer:
		if time_remaining < 0:
			transition.emit(self, timeout_state.name)
			return true
		time_remaining -= delta
	return false


func check_distance() -> bool:
	if direction.length_squared() > max_distance * max_distance:
		transition.emit(self, stop_chase_state.name)
		return true
	return false


# Leaving gravity as part of this check unless there's a need to decouple
func is_airborne(delta: float) -> bool:
	if not parent.is_on_floor() && gravity != 0:
		parent.velocity += gravity * Vector2.DOWN * delta
		return true
	return false


func animate_movement() -> void:
	if parent.is_on_floor():
		animations.play(animation_name)
	else:
		animations.play(jump_animation_name)


func decelerate(delta: float):
	parent.velocity.x = lerpf(parent.velocity.x, 0.0, (1 - exp(-7 * delta)))


func move_horizontal():
	velocity.x = move_sign * direction.x * move_speed


func move_vertical():
	# Walk allows jumps when the player is sufficiently above the enemy, determined by the JUMP_MINIMUM_Y_VECTOR
	# jump_strength of 0 means no jumping ever
	if movement_type == "Walk":
		var jump := jump_strength
		if direction.y > JUMP_MINIMUM_Y_VECTOR:
			jump = 0
		velocity.y = move_sign * direction.y * jump
	# Jump gives a full jump_strength 
	elif movement_type == "Jump":
		velocity.y = (direction.y / 4 - 1) * jump_strength
	# Float uses move_speed instead of jump_strength, meant to use with gravity disabled on state_machine
	elif movement_type == "Float":
		velocity.y = move_sign * direction.y * move_speed
