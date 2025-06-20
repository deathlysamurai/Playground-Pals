extends Block
class_name ItemBlock

@export var gravity: float = 3600.0
@export var initial_bounce_y_speed: float = -360.0
@export var spawned_item: PackedScene

@onready var bounce_timer: Timer = $BounceTimer
@onready var preview_sprite: Sprite2D = $PreviewSprite

var y_speed: float = 0.0
var orig_y_position: float
var hit_block_sprite: Texture
var block_hit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orig_y_position = sprite_2d.position.y
	hit_block_sprite = load("res://assets/kenney_new-platformer-pack-1.0/Sprites/Tiles/Default/block_yellow.png")
	preview_sprite.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bounce_timer.is_stopped():
		sprite_2d.position.y = orig_y_position
		y_speed = 0.0
	else:
		y_speed += gravity * delta
		sprite_2d.position.y += y_speed * delta

func _bounce() -> void:
	y_speed = initial_bounce_y_speed
	bounce_timer.start()

func _spawn_item() -> void:
	var item = spawned_item.instantiate()
	item.position = block_position
	item.position.y -= sprite_2d.get_rect().size.y
	add_child(item)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not block_hit:
		_bounce()
		Callable(_spawn_item).call_deferred()
		sprite_2d.texture = hit_block_sprite
		block_hit = true
