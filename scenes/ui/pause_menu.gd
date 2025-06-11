extends CanvasLayer

@export var menu_scene: PackedScene
@export var options_scene: PackedScene

var current_scene: PackedScene

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var restart_button: Button = %RestartButton
@onready var menu_button: Button = %MenuButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%MenuButton.pressed.connect(on_menu_button_pressed)
	%OptionsButton.pressed.connect(on_options_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func on_menu_button_pressed():
	get_tree().paused = false
	if menu_scene == null: queue_free()
	get_tree().change_scene_to_packed(menu_scene)


func on_options_button_pressed():
	get_tree().paused = false
	if options_scene == null: queue_free()
	get_tree().change_scene_to_packed(options_scene)


func on_quit_button_pressed():
	get_tree().quit()
