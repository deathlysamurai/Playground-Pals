extends State
class_name EnemyWander

## State to use after wandering time ends.
@export var stop_wander_state: State
## State to use when player is closer that [param alert_distance].
@export var alerted_state: State
@export var minimum_wander: float = 4
@export var maximum_wander: float = 8
@export var move_speed: float = 15.0
@export var alert_distance: float = 64 * 4 # 64px per tile, 4 tiles away

var move_direction: Vector2
var wander_time: float
var player: CharacterBody2D

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(minimum_wander, maximum_wander)


func enter():
	super()
	player = get_tree().get_first_node_in_group("player")
	randomize_wander()


func update(delta: float):
	if player.global_position.distance_squared_to(parent.global_position) < pow(alert_distance, 2):
		transition.emit(self, alerted_state.name)
		return
	if wander_time > 0:
		wander_time -= delta
	else:
		transition.emit(self, stop_wander_state.name)


func physics_update(delta: float):
	if not parent.is_on_floor():
		parent.velocity += gravity * Vector2.DOWN * delta
		return
	
	if parent:
		parent.velocity = move_direction * move_speed
