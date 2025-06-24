extends PlayerState

@export var jump_charged_sound: AudioStreamPlayer2D
@export var power_jump_charge_time: float = 0.5

# Boolean check for if this is exiting to a jump or a different state. Possible race condition if state is changed elsewhere.
var jump_charged := false


func enter() -> void:
	super()
	await get_tree().create_timer(power_jump_charge_time).timeout
	if player.state_machine.current_state == self:
		high_jump_charged()


func exit() -> void:
	jump_charged = false


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	player.handle_falling()
	player.handle_jump(jump_charged)
	player.handle_horizontal_movement(_delta)
	if player.move_direction_x != 0:
		transition.emit(self, "walk")
	if not player.input_down:
		transition.emit(self, "idle")


func high_jump_charged():
	jump_charged_sound.play()
	jump_charged = true
