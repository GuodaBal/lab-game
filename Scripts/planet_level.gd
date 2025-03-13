extends "level.gd"


func _input(event: InputEvent) -> void:
	var level_complete = true
	if Input.is_action_just_released("click"):
		for node in get_children():
			if node.is_in_group("item"):
				if node.connected_to == null || node.correct_id != node.connected_to.correct_id:
					level_complete = false
		if level_complete:
			level_complete()
			

func _on_button_pressed() -> void:
	return_to_main()
