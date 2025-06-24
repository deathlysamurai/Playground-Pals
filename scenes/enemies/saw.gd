extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	state_machine.init(self, animated_sprite)
	hurtbox_component.hurtbox_triggered.connect(on_hurtbox_triggered)


func _physics_process(delta: float) -> void:
	# Checks if the entity has fallen too far and removes from game
	if global_position.y >= 10000:
		queue_free()
	
	move_and_slide()
	scale_animation_speed()
	# Change visuals left/right orientation
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(move_sign, 1)


func scale_animation_speed() -> void:
	if state_machine.current_state.name == "Idle":
		animated_sprite.speed_scale = 1.0
	elif state_machine.current_state.name == "Chase":
		animated_sprite.speed_scale = 1.0
	elif state_machine.current_state.name == "Wander":
		animated_sprite.speed_scale = .33


func on_hurtbox_triggered(direction) -> void:
	$AudioStreamPlayer2D.play()
