extends Node
class_name HitFlashComponent

@export var health_component: HealthComponent
@export var sprite: AnimatedSprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready() -> void:
	health_component.health_changed.connect(on_health_changed)
	sprite.material = hit_flash_material


func on_health_changed(damage):
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	# The shader just turns the whole texture full white, excluding transparency.
	# This tween handles the fadeout to normal.
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
