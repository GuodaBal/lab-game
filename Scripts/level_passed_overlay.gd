extends Control

func _ready() -> void:
	GlobalAudioStreamPlayer.play_level1_sound()


func _on_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	get_tree().change_scene_to_file("res://Scenes/levels_menu.tscn")
