extends CanvasLayer

@export var player_icon_scene: PackedScene
@export var heart_icon_scene: PackedScene

var player_health_component: HealthComponent

@onready var status_container: HBoxContainer = %StatusContainer
@onready var inventory_container: HBoxContainer = %InventoryContainer
@onready var heart_icon_container: HBoxContainer = %HeartIconContainer


func _ready() -> void:
	player_health_component = get_tree().get_first_node_in_group("player").health_component
	GameEvents.player_health_changed.connect(on_player_health_changed)
	
	update_heart_containers()


func update_heart_containers():
	var heart_containers = round(player_health_component.get_max_health() / 2)
	var current_health = player_health_component.get_current_health()
	var remaining_health_allocation = current_health
	
	# Currently rebuilds the tree from scratch if the max heart containers don't match
	# Happy to hear better solutions as I'm not happy with this one - Robert
	var heart_icon_container_children = heart_icon_container.get_children()
	if not heart_containers == heart_icon_container_children.size():
		for i in heart_icon_container_children.size():
			heart_icon_container_children[i].queue_free()
		for i in heart_containers:
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


func on_player_health_changed():
	update_heart_containers()
