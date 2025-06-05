extends Node
class_name InventoryManager

var current_inventory: Dictionary = {}


func _ready() -> void:
	GameEvents.player_inventory_add_to.connect(on_inventory_added_to)


func add_to_inventory(item: InventoryObject, count: int):
	if not current_inventory.has(item.id):
		current_inventory[item.id] = {
			"resource": item,
			"quantity": count
			}
	else:
		current_inventory[item.id]["quantity"] += count
	inventory_change()


func remove_from_inventory(item: InventoryObject, count: int):
	if current_inventory.has(item.id):
		current_inventory[item.id]["quantity"] -= count
		if current_inventory[item.id]["quantity"] <= 0:
			current_inventory.erase(item.id)
	inventory_change()


func inventory_change():
	GameEvents.emit_player_inventory_changed(get_current_inventory())


func get_current_inventory():
	var current_inventory_dupe = current_inventory.duplicate()
	return current_inventory_dupe


func on_inventory_added_to(item: InventoryObject, count: int):
	if count > 0:
		add_to_inventory(item, count)
	else:
		remove_from_inventory(item, count)
