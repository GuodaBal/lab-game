extends "level.gd"

func _input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_released("click") and !complete:
		await get_tree().physics_frame
		var level_complete = true
		var connected_item_count = 0
		for node in get_children():
			if node.is_in_group("item"):
				if node.connected_to:
					if node.connected_to.correct_id != node.correct_id:
						level_complete = false
						break
					else:
						connected_item_count += 1
		# Ensure exactly the expected number of items are connected and correct (5 in your example)
		if level_complete and connected_item_count == 5:
			level_complete(true)




func _on_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	return_to_main()
