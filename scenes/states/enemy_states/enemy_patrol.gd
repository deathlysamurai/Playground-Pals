extends State
class_name EnemyPatrol

@export var alerted_state: State
@export var vision_area: Area2D
@export var hitbox: HitboxComponent

var vision_collider: CollisionShape2D
var vision_disable = func(disabled: bool): vision_collider.disabled = disabled

func init():
	if vision_area == null:
		push_error("%s is missing variables in the EnemyPatrol based node" % parent.owner.name)
	vision_collider = vision_area.get_child(0) as CollisionShape2D
	vision_area.area_entered.connect(on_area_entered)


func enter():
	vision_disable.call_deferred(false)
	hitbox.disable()


func exit():
	vision_disable.call_deferred(true)
	hitbox.enable()


func disable_vision_collider(disable: bool):
	vision_collider.disabled = disable


func on_area_entered(other_area: Area2D):
	transition.emit(self, alerted_state.name)
