extends Node2D

var complete = false
var menu_overlay = null

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
			if !GlobalVariables.stars_collected.has(get_tree().get_current_scene().get_name()):
				GlobalVariables.stars_collected.append(get_tree().get_current_scene().get_name())
			add_child(overlay)
		else:
			var overlay = load("res://Scenes/level_failed_overlay.tscn").instantiate()
			add_child(overlay)
		$hint.visible = false

func return_to_main() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		print_debug("bb")
		if menu_overlay:
			for node in get_children(true):
				node.process_mode = PROCESS_MODE_INHERIT
			get_parent().remove_child(menu_overlay)
			menu_overlay = null
		else:
			menu_overlay = load("res://Scenes/overlay_menu.tscn").instantiate()
			for node in get_children(true):
				node.process_mode = PROCESS_MODE_DISABLED
			add_sibling(menu_overlay)
