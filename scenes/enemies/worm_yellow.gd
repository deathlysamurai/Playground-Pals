extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D


func _ready() -> void:
	state_machine.init(self, animated_sprite)


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(-move_sign, 1)
