extends Control

func _ready() -> void:
	GlobalAudioStreamPlayer.play_bg_music()
	
func _on_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	get_tree().change_scene_to_file("res://Scenes/Levels/physics_1.tscn")


func _on_options_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	get_tree().change_scene_to_file("res://Scenes/settings_menu.tscn")
	

func _on_exit_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	get_tree().quit()


func _on_levelsbutton_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	get_tree().change_scene_to_file("res://Scenes/levels_menu.tscn")
