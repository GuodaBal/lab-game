extends Button

@onready var level
var entered = false
var scale_up = Vector2(1.1, 1.1)

func _on_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	get_tree().change_scene_to_file("res://Scenes/Levels/"+level+".tscn")

func _process(delta: float) -> void:
	if entered:
		scale = lerp(scale, scale_up, delta*5)
	else:
		scale = lerp(scale, Vector2(1.0, 1.0), delta*5)

func _on_mouse_entered() -> void:
	GlobalAudioStreamPlayer.play_hover_sound()
	entered = true

func _on_mouse_exited() -> void:
	entered = false
