extends "level.gd"

func _on_button_pressed() -> void:
	return_to_main()

func _on_button_2_pressed() -> void:
	get_tree().reload_current_scene()
