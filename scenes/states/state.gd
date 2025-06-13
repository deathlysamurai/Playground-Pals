extends Node
class_name State

@warning_ignore("unused_signal")
signal transition(state: State, new_state_name: String)

@export var animation_name: String

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var parent: CharacterBody2D


func enter():
	print("%s entered %s state." % [parent.name, self.name])
	# Future use to automatically play animations when in a new state.
	#parent.animations.play(animation_name)


func exit():
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass
