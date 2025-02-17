extends Node2D


func _input(event: InputEvent) -> void:
	var level_complete = true
	if Input.is_action_just_released("click"):
		for node in get_children():
			if node.is_in_group("item"):
				if node.connected_to == null || node.correct_id != node.connected_to.correct_id:
					level_complete = false
		if level_complete:
			print_debug("LEVEL COMPLETE")
