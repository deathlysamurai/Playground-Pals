extends Node2D

@export var item_resource: InventoryObject
@export var count: int = 1

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.texture = item_resource.world_texture
	$PickupArea2D.area_entered.connect(on_area_entered, CONNECT_ONE_SHOT)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(-90)
	rotation = lerp_angle(rotation, target_rotation, (1 - exp(-2 * get_process_delta_time())))


func collect():
	GameEvents.emit_game_over(true)
	queue_free()


func on_area_entered(other_area: Area2D):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2(2, 2), .25).set_delay(.1)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .15).set_delay(.35)
	tween.chain()
	tween.tween_callback(collect)
