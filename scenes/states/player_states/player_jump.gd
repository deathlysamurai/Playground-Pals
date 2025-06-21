extends PlayerState

@export var jump_sound: AudioStreamPlayer2D
@export var high_jump_sound: AudioStreamPlayer2D


func enter() -> void:
	super()
	var jump_speed = (player.JUMP_VELOCITY * player.POWER_JUMP_FACTOR) if player.power_jump else player.JUMP_VELOCITY
	player.velocity.y = jump_speed
	if player.power_jump:
		high_jump_sound.play()
	else:
		jump_sound.play()
	player.power_jump = false


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	player.apply_gravity(_delta)
	player.handle_horizontal_movement(_delta)
	player.handle_jump()
	if player.velocity.y >= 0:
		transition.emit(self, "fall")
	
