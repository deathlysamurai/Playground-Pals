extends Area2D
class_name HurtboxComponent
## Component used for applying damage to a [HealthComponent] when colliding with a HitboxComponent
## Requires a HealthComponent in the scene

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	var hitbox_component = other_area as HitboxComponent
	#print(owner.name + " hurt by " + other_area.owner.name + " for " + str(hitbox_component.damage))
	health_component.damage(hitbox_component.damage)
