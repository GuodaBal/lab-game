extends "level.gd"

func _ready() -> void:
	$RichTextLabel2.visible = false
	$Button2.visible = false

func _on_button_pressed() -> void:
	return_to_main()
	
func level_failed():
	$ColorRect.visible = true
	$RichTextLabel2.visible = true
	$Button2.visible = true


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/find_densities.tscn")
