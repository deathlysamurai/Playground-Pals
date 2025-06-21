extends PlayerState


func enter() -> void:
	super()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	player.apply_gravity(_delta)
	player.handle_jump()
	player.handle_horizontal_movement(_delta)
	player.handle_landing()
