extends Control

@export var rows = 0
@export var star_count_needed = []

@onready var container := $GridContainer as GridContainer
@onready var button = preload("res://Scenes/LevelButton.tscn");


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var colors = {"Blue": "","Purple": "PurpleLevelButton","Green": "GreenLevelButton","Yellow": "YellowLevelButton","Red": "RedLevelButton"}
	var subjects = ["physics", "astronomy", "chemistry", "electronics", "biology"]
	for row in rows:
		for i in range(colors.keys().size()):
			var button_instance = button.instantiate()
			
			var color = colors.keys()[i]
			var theme_variation = colors[color]
			if theme_variation != "":
				button_instance.theme_type_variation = theme_variation
			
			button_instance.level = subjects[i] + "_" + str(row + 1)
			container.add_child(button_instance)
			if star_count_needed[row] > GlobalVariables.stars_collected:
				button_instance.disabled = true


func _on_texture_button_pressed() -> void:
	GlobalAudioStreamPlayer.play_click_sound()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
