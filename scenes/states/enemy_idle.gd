extends State
class_name EnemyIdle

## Connects the state to use after waking from idle.
@export var wander_state: State
@export var minimum_idle: float = 1
@export var maximum_idle: float = 8


var idle_time: float

func randomize_idle_time():
	idle_time = randf_range(minimum_idle, maximum_idle)


func enter():
	randomize_idle_time()


func update(delta: float):
	if idle_time > 0:
		idle_time -= delta
	elif wander_state:
		print("%s on %s is changing to wander state." % [self.name, parent.name])
		transition.emit(self, wander_state.name)
	else:
		print("%s on %s is missing a wander state." % [self.name, parent.name])
		randomize_idle_time()


func physics_update(delta: float):
	# If falling, add gravity
	if not parent.is_on_floor():
		parent.velocity += gravity * Vector2.DOWN * delta
		return
	# If on ground, slow to a stop
	parent.velocity.x = lerpf(parent.velocity.x, 0, (1 - exp(-100 * delta)))
