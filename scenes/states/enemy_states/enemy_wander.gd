extends State
class_name EnemyWander

## State to use after wandering time ends.
@export var stop_wander_state: State
## State to use when player is closer that [param alert_distance].
@export var alerted_state: State
## Length of time after entering the state where alert will not trigger
@export var alert_delay: float = 1.5
@export var minimum_wander: float = 4
@export var maximum_wander: float = 8
@export var move_speed: float = 15.0
@export var alert_distance: float = 64 * 4 # 64px per tile, 4 tiles away

var move_direction: Vector2
var alert_time: float
var wander_time: float
var player: CharacterBody2D


func enter():
	super()
	player = get_tree().get_first_node_in_group("player")
	if gravity != 0:
		randomize_wander_grounded()
	else:
		randomize_wander_floating()
	alert_time = alert_delay


func update(delta: float):
	if check_alert(delta):
		transition.emit(self, alerted_state.name)
		return
	if wander_time > 0:
		wander_time -= delta
	else:
		transition.emit(self, stop_wander_state.name)


func physics_update(delta: float):
	
	if not parent.is_on_floor() && gravity != 0:
		parent.velocity += gravity * Vector2.DOWN * delta
		return
	
	if parent:
		parent.velocity = move_direction * move_speed


func randomize_wander_grounded():
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(minimum_wander, maximum_wander)


func randomize_wander_floating():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	print(move_direction)
	wander_time = randf_range(minimum_wander, maximum_wander)


func check_alert(delta: float) -> bool:
	if alert_time > 0:
		alert_time -= delta
		return false
	elif player.global_position.distance_squared_to(parent.global_position) < pow(alert_distance, 2):
		return true
	return false
