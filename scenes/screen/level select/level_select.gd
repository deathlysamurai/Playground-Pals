extends Control

const level_folder_path = "res://scenes/levels/"

@onready var v_box_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_levels()
	
	if v_box_container.get_child_count() > 0:
		v_box_container.get_child(0).grab_focus()

func get_levels() -> void:
	var level_paths = DirAccess.get_directories_at(level_folder_path)
	print(level_paths)
	for level_path in level_paths:
		print(level_path)
		var button = Button.new()
		button.text = level_path
		
		v_box_container.add_child(button)
		
		button.pressed.connect(func():
			get_tree().change_scene_to_file(level_folder_path + level_path + "/" + level_path.replace(" ", "_") + ".tscn")
		)
