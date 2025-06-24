extends PlayerState


func enter() -> void:
	super()
	player.hitbox_component.enable()


func exit() -> void:
	player.hitbox_component.disable()


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	player.apply_gravity(_delta, player.falling_gravity)
	player.handle_jump()
	player.handle_horizontal_movement(_delta)
	player.handle_landing()
