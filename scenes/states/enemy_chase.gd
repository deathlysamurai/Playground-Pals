extends State
class_name EnemyChase

## State to use when player is beyond [param max_distance].
@export var stop_chase_state: State
## How fast the enemy should move horizontally.
@export var move_speed: float = 50.0
## Strength of vertical components. Zero (0) means there's only horizontal speed.
@export var jump_strength: float = 0.0
## The distance from player where the enemy stops exits this state.
@export var max_distance: float = 64 * 8 # 64px per tile, 8 tiles away
## Does the enemy move toward the player ([param On] / [code]true[/code]) [br]
## Or away from the player ([param Off] / [code]false[/code])
@export var toward_player: bool = true

var player: CharacterBody2D


func enter():
	super()
	player = get_tree().get_first_node_in_group("player")


func physics_update(delta: float):
	if not parent.is_on_floor():
		parent.velocity += gravity * Vector2.DOWN * delta
		return
	
	var direction = player.global_position - parent.global_position
	if direction.length_squared() > max_distance * max_distance:
		transition.emit(self, stop_chase_state.name)
		return
	var move_sign = 1.0
	if !toward_player:
		move_sign = -1
	parent.velocity = move_sign * direction.normalized() * Vector2(move_speed, jump_strength)
