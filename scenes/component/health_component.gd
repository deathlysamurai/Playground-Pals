extends Node
class_name HealthComponent
## Provides health information and options for manipulation

signal died
signal health_changed

var _current_health: int

@export var _max_health: int = 10
@export_range(0.0, 1.0, 0.05, "or_greater") var _invulnerable_time: float = 0.1

@onready var timer: Timer = $Timer

func _ready() -> void:
	_current_health = _max_health
	timer.wait_time = _invulnerable_time


## If the component can be hurt, will subtract [param damage_amount] from [param current_health].
## Negative damage will heal. Bounded by 0 and [param max_health]. [br]
## [param max_health] is adjusted down when odd, to match icon set.
func damage(damage_amount: int):
	if not timer.is_stopped():
		return
	timer.start()
	
	var max_health_adjusted = _max_health
	if not _max_health % 2 == 0:
		max_health_adjusted -= 1
	
	_current_health = max(_current_health - damage_amount, 0)
	_current_health = min(_current_health, max_health_adjusted)
	
	health_changed.emit(self)
	Callable(check_death).call_deferred()


func get_current_health():
	return _current_health


func get_max_health():
	return _max_health


func check_death():
	if _current_health == 0:
		died.emit(self)
		owner.queue_free()
