extends "level.gd"

func _input(event: InputEvent) -> void:
	super(event)
	var level_complete = true
	if Input.is_action_just_released("click") && !complete:
		await get_tree().physics_frame
		for node in get_children():
			if node.is_in_group("item"):
				GlobalAudioStreamPlayer.play_place_sound()
				if (!node.connected_to && node.correct_id != 0) || (node.connected_to && node.connected_to.correct_id != node.correct_id):
					level_complete = false
					break
		if level_complete:
			level_complete(true)
