extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Arrange_planets.tscn")


func _on_options_pressed() -> void:
	get_tree().quit()
