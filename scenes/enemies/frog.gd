extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var collision_shape_2d: CollisionShape2D = $Visuals/HitboxComponent/CollisionShape2D
@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	state_machine.init(self, animated_sprite)
	hurtbox_component.hurtbox_triggered.connect(on_hurtbox_triggered)


func _physics_process(delta: float) -> void:
	# Checks if the entity has fallen too far and removes from game
	if global_position.y >= 10000:
		queue_free()
	
	move_and_slide()
	# Change visuals left/right orientation
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(-move_sign, 1)


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node == null:
		return Vector2.ZERO
	return (player_node.global_position - global_position).normalized()


func on_hurtbox_triggered(direction) -> void:
	$AudioStreamPlayer2D.play()
