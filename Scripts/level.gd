extends Node2D


func _ready() -> void:
	$ColorRect.visible = false
	$RichTextLabel.visible = false
	$Button.visible = false
	GlobalAudioStreamPlayer.play_bg_music()

func level_complete():
	await get_tree().create_timer(1.0).timeout
	$ColorRect.visible = true
	$RichTextLabel.visible = true
	$Button.visible = true

func return_to_main() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
