extends State
class_name EnemyWander

## State to use after wandering.
@export var idle_state: State
## State to use when player is close
@export var chase_state: State
@export var minimum_wander: float = 4
@export var maximum_wander: float = 8
@export var move_speed: float = 10.0
@export var chase_distance: float = 64 * 4 # 64px per tile, 4 tiles away

var move_direction: Vector2
var wander_time: float
var player: CharacterBody2D

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(minimum_wander, maximum_wander)


func enter():
	player = get_tree().get_first_node_in_group("player")
	randomize_wander()


func update(delta: float):
	if player.global_position.distance_squared_to(parent.global_position) < (chase_distance * chase_distance):
		print("%s on %s is changing to chase state." % [self.name, parent.name])
		transition.emit(self, chase_state.name)
		return
	if wander_time > 0:
		wander_time -= delta
	else:
		print("%s on %s is changing to idle state." % [self.name, parent.name])
		transition.emit(self, idle_state.name)


func physics_update(delta: float):
	if not parent.is_on_floor():
		parent.velocity += gravity * Vector2.DOWN * delta
		return
	
	if parent:
		parent.velocity = move_direction * move_speed
