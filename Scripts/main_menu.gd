extends Control

func _ready() -> void:
	GlobalAudioStreamPlayer.play_bg_music()
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/find_densities.tscn")


func _on_options_pressed() -> void:
	pass
	

func _on_exit_button_pressed() -> void:
	get_tree().quit()
