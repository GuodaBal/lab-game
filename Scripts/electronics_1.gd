extends "level.gd"

@onready var items = $Items
@onready var item_destinations = $ItemDestinations

func _input(event: InputEvent) -> void:
	var level_complete = true
	if Input.is_action_just_released("click") && !complete:
		#await get_tree().physics_frame
		await get_tree().create_timer(0.5).timeout
		for node in items.get_children():
			if node.is_in_group("lamp") && !node.powered:
				level_complete = false
			#if !node.connected_to || node.connected_to.correct_id == 0:
				#level_complete = false
				#break
			#if node.is_in_group("switch") && !node.closed:
				#level_complete = false
				#break
		if level_complete:
			level_complete(true)
			

func _on_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	return_to_main()

func turn_on_wires():
	var circuit_connected = true
	await get_tree().create_timer(0.2).timeout
	for node in items.get_children():
		if !node.connected_to || node.connected_to.correct_id == 0:
			circuit_connected = false
			break
		if node.is_in_group("switch") && !node.closed:
			circuit_connected = false
			break
	if circuit_connected:
		for node in item_destinations.get_children():
			if node.has_wire:
				node.has_power = true
		for node in items.get_children():
			if node.is_in_group("lamp"):
				node.light()
func turn_off_wires():
	for node in item_destinations.get_children():
		if node.has_wire:
			node.has_power = false
	for node in items.get_children():
		if node.is_in_group("lamp"):
			node.light_off()
