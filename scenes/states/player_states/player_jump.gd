extends PlayerState

@export var jump_sound: AudioStreamPlayer2D
@export var high_jump_sound: AudioStreamPlayer2D


func enter() -> void:
	super()
	var jump_speed = (player.JUMP_VELOCITY * player.POWER_JUMP_FACTOR) if player.power_jump_ready else player.JUMP_VELOCITY
	player.velocity.y = jump_speed
	if player.power_jump_ready:
		high_jump_sound.play()
	else:
		jump_sound.play()
	player.power_jump_ready = false
	player.item_box_collision.disabled = false


func exit() -> void:
	player.item_box_collision.disabled = true


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	falling_transition()
	player.apply_gravity(_delta)
	player.handle_horizontal_movement(_delta)
	player.handle_jump()


func falling_transition() -> void:
	if player.velocity.y >= 0:
		transition.emit(self, "fall")
	if not player.input_jump:
		player.velocity.y *= player.JUMP_CANCEL_FACTOR
		transition.emit(self, "fall")
