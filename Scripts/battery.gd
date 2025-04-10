extends "physics_item.gd"

func select():
	if connected_to && connected_to.has_wire:
		connected_to.depower_connections()
		if connected_to.can_be_powered:
			connected_to.depowered_from_item()
	super()
	
var was_snapped := false

func _physics_process(delta: float) -> void:
	super(delta)

	if connected_to:
		var close_enough = position.distance_to(connected_to.position) < 5

		if close_enough:
			if !was_snapped:
				# Just got placed in!
				GlobalAudioStreamPlayer.play_place_sound()
				was_snapped = true

				for child in get_children():
					if child is CollisionShape2D:
						child.disabled = true

			# Lock it in place
			freeze = true
		else:
			# Item was moved away from slot
			was_snapped = false
			freeze = false
	else:
		was_snapped = false  # No connection = can't be snapped
				

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
