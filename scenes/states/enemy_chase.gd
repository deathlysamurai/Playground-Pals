extends State
class_name EnemyChase

## Connects the state to use when player is too far away.
@export var wander_state: State
## How fast the enemy should move when chasing the player.
@export var move_speed: float = 50.0
## The distance where the enemy stops chasing the player.
@export var max_distance: float = 64 * 8 # 64px per tile, 8 tiles away

var player: CharacterBody2D


func enter():
	player = get_tree().get_first_node_in_group("player")


func physics_update(delta: float):
	if not parent.is_on_floor():
		parent.velocity += gravity * Vector2.DOWN * delta
		return
	
	var direction = player.global_position - parent.global_position
	if direction.length_squared() > max_distance * max_distance:
		print("%s on %s is changing to wander state." % [self.name, parent.name])
		transition.emit(self, wander_state.name)
		return
	parent.velocity = direction.normalized() * move_speed
