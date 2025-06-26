extends State
class_name EnemyReturn

## State to transition to after returning.
@export var on_return_state: State
@export var move_speed: float = 250


var starting_position: Vector2 = Vector2.ZERO
var direction: Vector2
var distance


func init():
	set_starting_position()


func enter():
	super()
	parent.velocity = Vector2.ZERO


func physics_update(delta: float):
	# If falling, add gravity
	if not parent.is_on_floor() && gravity != 0:
		parent.velocity += gravity * Vector2.DOWN * delta
		return
	parent.global_position = Vector2(
		move_toward(parent.position.x, starting_position.x, delta * move_speed),
		move_toward(parent.position.y, starting_position.y, delta * move_speed)
	)
	if parent.global_position == starting_position:
		transition.emit(self, on_return_state.name)


func set_starting_position():
	starting_position = parent.global_position


func get_direction():
	if starting_position == Vector2.ZERO:
		push_warning("%s has a starting position of Vector2.ZERO" % parent.owner.name)
	direction = starting_position - parent.global_position
