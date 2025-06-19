extends Control

var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready() -> void:
	%OptionsButton.pressed.connect(_on_options_button_pressed)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level 1/level_1.tscn")


func _on_select_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screen/level select/level_select.tscn")


func _on_options_button_pressed() -> void:
	add_child(options_scene.instantiate())
