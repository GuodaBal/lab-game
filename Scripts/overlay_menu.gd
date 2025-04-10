extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	queue_free()


func _on_level_selection_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels_menu.tscn")
	queue_free()


func _on_settings_pressed() -> void:
	var instance = load("res://Scenes/settings_menu.tscn").instantiate()
	add_child(instance)
