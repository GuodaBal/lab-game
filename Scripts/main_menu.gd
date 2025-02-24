extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Drag_and_drop_testing.tscn")


func _on_options_pressed() -> void:
	get_tree().quit()
