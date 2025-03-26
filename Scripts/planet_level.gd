extends "level.gd"


func _input(event: InputEvent) -> void:
	var level_complete = true
	await get_tree().physics_frame
	if Input.is_action_just_released("click") && !complete:
		for node in get_children():
			if node.is_in_group("item"):
				if node.connected_to == null || node.correct_id != node.connected_to.correct_id:
					level_complete = false
					break
		if level_complete:
			print_debug("complete")
			level_complete(true)
			

func _on_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	return_to_main()
