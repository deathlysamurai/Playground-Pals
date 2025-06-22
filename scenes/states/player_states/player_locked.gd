extends PlayerState
## A state for locking the player out of controls, letting them be controlled by code or otherwise.
## For cutscene type movement, like when Mario enters or exits a stage.


func enter() -> void:
	super()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
