Using [Godot 4.4.1](https://godotengine.org/download/archive/)

After cloning the repo, open Godot and click "Import", navigating to your cloned repo.

# 2D Physics Layers
[Reference](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html)\
Note that the `collision_layer` is where the collision area exists, and that `collision_mask` is where the area is scanning.\
This is my (Robert's) thoughts and assumptions on what these layers are for:
1. 'Environment': Static parts of the level, such as the ground. CharacterBody2D's should have this as a `collision_mask`, and terrain should have this as a `collision_layer`.
2. 'Player': The layer that the player exists in. Enemy `HurtboxComponent` should exist in this layer if you want the player's `HitboxComponent` to damage them.
3. 'Items': The player has an Area2D on this layer, and all pickup items should have this as a mask
4. 'Enemy': I have this set as the player's `HitboxComponent`'s mask, as in anything existing on this layer is assumed to be damaging to the player.
5. 'EntityCollision': This is for characters that you want to collide with other characters, such that the player or other enemies can't pass through each other.
6. 'Hazard': Static damage sources, such as spikes. These could theoretically also hurt enemies

# Components
Components can be added to any scene to give it new effects/interactions. Please note that you should add an _instance_ of the component to the scene, not the component directly.\
Each component has it's own parameters to setup.

## HitboxComponent
Used to cause "damage" to `HurtboxComponent`s. Only stores damage integer and collision info.
### Setup:
Add Child Node: `CollisionShape2D`, this will be the area that when collided with causes damage.  
Damage: Positive numbers cause damage, negative numbers heal.  
Collision Layer: The layer you want to be affected by this Hitbox.  
Collision Mask: Should be empty, this node is not actively scanning for any collisions.  

## HurtboxComponent
Listens for `HitboxComponent`s and handles passing damage information to the `HealthComponent`.  
### Setup:
Add Child Node: `CollisionShape2D`, this will be the area that when collided with causes damage.  
HealthComponent: Requires a reference to the HealthComponent used by the parent scene  
Collision Layer: Should be empty, this setup assumes Hurtboxes are always scanning for Hitboxes, and never the opposite.  
Collision Mask: The layer with Hitboxes that concern this component.  

## HealthComponent
Handles changes to health values, entity death, and related signals.
### Setup:
Max Health: Integer value  
Invulnerable Time: Seconds of invulnerability after registering damage.  
