extends Node

@export var end_screen_scene: PackedScene


func _ready() -> void:
	GameEvents.player_health_setup.connect(on_player_health_setup)


func on_player_health_setup(health_component: HealthComponent):
	health_component.died.connect(on_player_died)


func on_player_died(component):
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
