extends State
class_name EnemyDash

const NONE := "None"
const HORIZONTAL := "Horizontal"
const VERTICAL := "Vertical"
const MAX_STALL_TIME := 1.5

## State to use when player is beyond [param max_distance].
@export var stop_dash_state: State
## How fast the enemy should move horizontally.
@export var move_speed: float = 300.0
## The max distance traveled before canceling dash.
@export var max_distance: float = 64 * 3 # 64px per tile, 10 tiles away
## Does the enemy move toward the player ([param On] / [code]true[/code]) [br]
## Or away from the player ([param Off] / [code]false[/code])
@export var toward_player: bool = true
## Optionally lock the direction of the dash into an axis
@export_enum(NONE, HORIZONTAL, VERTICAL) var direction_lock: String = NONE
## Time in between jumps. The time is between jumping actions, not landing.
@export_range(0, 2, .05) var move_delay: float = 0
## The [param String] name of the animation to play while delay ticks down.
@export var delay_animation_name: String


var player: Player
var velocity: Vector2
var direction: Vector2
var move_sign: float = 1.0
var starting_position: Vector2
var timeout: float = 0


func enter():
	player = get_tree().get_first_node_in_group("player") as Player
	starting_position = parent.global_position
	timeout = 0
	if delay_animation_name == null:
		delay_animation_name = animation_name
	animations.play(delay_animation_name)
	get_direction()
	set_velocity_limit()
	velocity = move_sign * direction * move_speed
	await get_tree().create_timer(move_delay).timeout
	if parent.state_machine.current_state != self:
		return
	animations.play(animation_name)
	parent.velocity = velocity
	print(parent.velocity)


func physics_update(delta: float):
	check_distance()
	if parent.velocity == Vector2.ZERO:
		timeout += delta
	if timeout > MAX_STALL_TIME:
		transition.emit(self, stop_dash_state.name)


func get_direction() -> void:
	direction = player.global_position - parent.global_position
	velocity = parent.velocity
	direction = direction.normalized()
	move_sign = 1.0 if toward_player else -1.0


func check_distance() -> void:
	var distance_traveled = starting_position.distance_squared_to(parent.global_position)
	if distance_traveled > max_distance * max_distance:
		transition.emit(self, stop_dash_state.name)


func set_velocity_limit():
	if direction_lock == "Horizontal":
		direction.y = 0
		direction = direction.normalized()
		return
	if direction_lock == "Vertical":
		direction.x = 0
		direction = direction.normalized()
		return
