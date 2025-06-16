extends State
class_name EnemyIdle

## State to transition to after waking from idle.
@export var on_wake_state: State
@export var minimum_idle: float = 1
@export var maximum_idle: float = 8


var idle_time: float


func randomize_idle_time():
	idle_time = randf_range(minimum_idle, maximum_idle)


func enter():
	super()
	randomize_idle_time()


func update(delta: float):
	if idle_time > 0:
		idle_time -= delta
	elif on_wake_state:
		transition.emit(self, on_wake_state.name)
	else:
		randomize_idle_time()


func physics_update(delta: float):
	# If falling, add gravity
	if not parent.is_on_floor():
		parent.velocity += gravity * Vector2.DOWN * delta
		return
	parent.velocity.x = 0 # Stop the horizontal movement when resting.
