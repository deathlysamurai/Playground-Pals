extends Node
## Provides [signals] used for updating UI and managers

## Passes a reference to the player's [param HealthComponent] after setup[br]
## Note: This is my workaround for what I think were race conditions - Robert
signal player_health_setup(health_component: HealthComponent)
signal player_health_changed(current_health: int)
signal player_inventory_changed(inventory: Dictionary)
signal player_inventory_add_to(item: InventoryObject, count: int)
signal game_over(success: bool) ## success == true is the win condition


func emit_player_health_setup(health_component: HealthComponent):
	player_health_setup.emit(health_component)


func emit_player_health_changed():
	player_health_changed.emit()


func emit_player_inventory_changed(current_inventory: Dictionary):
	player_inventory_changed.emit(current_inventory)


func emit_player_inventory_add_to(item: InventoryObject, count: int):
	player_inventory_add_to.emit(item, count)	


func emit_game_over(success: bool):
	game_over.emit(success)
