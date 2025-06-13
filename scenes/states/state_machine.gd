extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func init(parent: CharacterBody2D) -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_child_transition)
			child.parent = parent
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


# Foreward the process function to the active state
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


# Foreward the physics process function to the active state
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
