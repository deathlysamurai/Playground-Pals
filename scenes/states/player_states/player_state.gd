extends State
class_name PlayerState

var player: Player

func _set_parent(node: CharacterBody2D) -> void:
	parent = node
	player = node
	return
