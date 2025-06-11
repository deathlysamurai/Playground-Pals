extends Block

var tile_map: TileMapLayer
var inventory_manager: InventoryManager

func _ready() -> void:
	tile_map = get_tree().current_scene.get_node("TileMapLayer")
	inventory_manager = get_tree().current_scene.get_node("InventoryManager")

func _on_area_2d_area_entered(area: Area2D) -> void:
	var inventory = inventory_manager.get_current_inventory()
	if tile_map && inventory.has("key_yellow"):
		var keys = inventory["key_yellow"]
		var tile_pos = tile_map.local_to_map(to_global(area.position))
		var cell_id = tile_map.get_cell_source_id(tile_pos)
		if cell_id != -1:
			var visited_positions = []
			_remove_lock_wall(tile_pos, cell_id, visited_positions)
			inventory_manager.remove_from_inventory(keys.resource, 1)

func _remove_lock_wall(hit_lock_pos: Vector2i, cell_id: int, visited_positions: Array) -> void:
	if visited_positions.has(hit_lock_pos):
		return
	if tile_map.get_cell_source_id(hit_lock_pos) != cell_id:
		return
		
	tile_map.erase_cell(hit_lock_pos)
	visited_positions.append(hit_lock_pos)

	_remove_lock_wall(Vector2i(hit_lock_pos.x, (hit_lock_pos.y + 1)), cell_id, visited_positions)
	_remove_lock_wall(Vector2i(hit_lock_pos.x, (hit_lock_pos.y - 1)), cell_id, visited_positions)
	_remove_lock_wall(Vector2i((hit_lock_pos.x + 1), hit_lock_pos.y), cell_id, visited_positions)
	_remove_lock_wall(Vector2i((hit_lock_pos.x - 1), hit_lock_pos.y), cell_id, visited_positions)
