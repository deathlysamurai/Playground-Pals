extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level 1/level_1.tscn")

func _on_select_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screen/level select/level_select.tscn")
