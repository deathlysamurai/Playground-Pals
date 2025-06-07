extends Node

@export var end_screen_scene: PackedScene


func _ready() -> void:
	GameEvents.game_over.connect(on_game_over)


func on_game_over(success: bool):
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	if !success:
		end_screen_instance.set_defeat()
