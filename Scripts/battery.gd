extends "physics_item.gd"

func select():
	if connected_to && connected_to.has_wire:
		connected_to.depower_connections()
		if connected_to.can_be_powered:
			connected_to.depowered_from_item()
	super()

func _physics_process(delta: float) -> void:
	super(delta)
	if connected_to && position.distance_to(connected_to.position) < 5:
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = true

func deselect():
	super()
	if connected_to && connected_to.has_wire:
		get_parent().get_parent().turn_on_wires()
		#if connected_to.wire_connected_to.size() > 1:
			#connected_to.power_connections()
			#if !connected_to.can_be_powered:
				#connected_to.powered_from_item()
			
func refresh():
	if connected_to && connected_to.has_wire:
		get_parent().get_parent().turn_off_wires()
		#connected_to.depower_connections()
		#await get_tree().process_frame
		#if connected_to && connected_to.has_wire:
			#connected_to.power_connections()
