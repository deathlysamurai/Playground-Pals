extends Node2D

@export var health_component: HealthComponent
@export var sprite: AnimatedSprite2D


func _ready() -> void:
	# Just grabs the first texture from the "idle" animation.
	$GPUParticles2D.texture = sprite.sprite_frames.get_frame_texture("idle", 0)
	health_component.died.connect(on_died)


func on_died():
	if owner == null || not owner is Node2D:
		return
	
	var spawn_position = owner.global_position
	
	# Detaches the DeathComponent from the parent, so that the parent can handle
	# removing itself from the game.
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	
	global_position = spawn_position
	$AnimationPlayer.play("default")
