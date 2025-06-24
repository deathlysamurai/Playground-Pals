extends PlayerState

@export var audio_player: AudioStreamPlayer2D
@export_range(0.0, 2.0, 0.05) var stun_duration := 0.25


func enter() -> void:
	super()
	await get_tree().create_timer(stun_duration).timeout
	player.state_machine.change_state("fall")


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
