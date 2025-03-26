extends Control

func _ready() -> void:
	GlobalAudioStreamPlayer.play_level2_sound()
	
func _on_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	get_tree().reload_current_scene()
