extends Node

signal died
signal health_changed

@export var max_health: int = 10
var current_health: int

func _ready() -> void:
	current_health = max_health


func damage(damage_amount: int):
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit(self)
	Callable(check_death).call_deferred()


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit(self)
		owner.queue_free()
