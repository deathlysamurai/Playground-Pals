extends CanvasLayer

@export var inventory_manager: InventoryManager
@export var player_icon_scene: PackedScene
@export var heart_icon_scene: PackedScene
@export var inventory_item_scene: PackedScene

var player_health_component: HealthComponent

@onready var status_container: HBoxContainer = %StatusContainer
@onready var inventory_container: VBoxContainer = %InventoryContainer
@onready var heart_icon_container: HBoxContainer = %HeartIconContainer


func _ready() -> void:
	GameEvents.player_health_setup.connect(on_player_health_setup)
	GameEvents.player_health_changed.connect(on_player_health_changed)
	GameEvents.player_inventory_changed.connect(on_inventory_changed)
	
	update_inventory(inventory_manager.get_current_inventory())


func _clear_container(container: Node):
	var container_children = container.get_children()
	for i in container_children.size():
			container_children[i].queue_free()


func update_heart_containers():
	var total_heart_containers = floori(player_health_component.get_max_health() / 2)
	var current_health = player_health_component.get_current_health()
	var remaining_health_allocation = current_health
	
	# Currently rebuilds the tree from scratch if the max heart containers don't match
	# Happy to hear better solutions as I'm not happy with this one - Robert
	var heart_icon_container_children = heart_icon_container.get_children()
	if not total_heart_containers == heart_icon_container_children.size():
		_clear_container(heart_icon_container)
		for i in total_heart_containers:
			heart_icon_container.add_child(heart_icon_scene.instantiate())
	
	for i in heart_icon_container_children.size():
		if remaining_health_allocation >= 2:
			heart_icon_container_children[i].set_heart_container(2)
			remaining_health_allocation -= 2
		elif remaining_health_allocation >= 1:
			heart_icon_container_children[i].set_heart_container(1)
			remaining_health_allocation -= 1
		elif remaining_health_allocation >= 0:
			heart_icon_container_children[i].set_heart_container(0)
		else:
			print("Heart container for loop inside update_heart_containers() failed")


func update_inventory(current_inventory: Dictionary):
	_clear_container(inventory_container)
	
	#var current_inventory_size = current_inventory.size()
	for item in current_inventory:
		var inventory_item_instance = inventory_item_scene.instantiate()
		inventory_container.add_child(inventory_item_instance)
		inventory_item_instance.update_item_display(current_inventory[item]["resource"], current_inventory)


func on_player_health_setup(health_component: HealthComponent):
	player_health_component = health_component
	update_heart_containers()


func on_player_health_changed():
	update_heart_containers()


func on_inventory_changed(current_inventory):
	update_inventory(current_inventory)
