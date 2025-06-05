extends Node
## Provides [signals] used for updating UI and managers

signal player_health_changed(current_health: int)
signal player_inventory_changed(inventory: Dictionary)


func emit_player_health_changed():
	player_health_changed.emit()


func emit_player_inventory_changed(current_inventory: Dictionary):
	player_inventory_changed.emit(current_inventory)
