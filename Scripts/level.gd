extends Node2D

var complete = false

func _ready() -> void:
	$hint.visible = true
	GlobalAudioStreamPlayer.play_bg_music()

func level_complete(won):
	if !complete:
		complete = true
		await get_tree().create_timer(1.0).timeout
		if won:
			var overlay = load("res://Scenes/level_passed_overlay.tscn").instantiate()
			for node in get_children(true):
				if "input_pickable" in node:
					node.input_pickable = false
			add_child(overlay)
		else:
			var overlay = load("res://Scenes/level_failed_overlay.tscn").instantiate()
			add_child(overlay)
		$hint.visible = false

func return_to_main() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
