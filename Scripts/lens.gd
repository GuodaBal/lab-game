extends "item.gd"

@export var bending_degrees = 0

@onready var area = $Area2D as Area2D

@onready var outline = preload("res://Assets/Shaders/outline_material.tres")

var org_position
var wanted_scale

func _ready() -> void:
	org_position = global_position
	area.set_collision_layer_value(3, false)
	outline = outline.duplicate()
	wanted_scale = scale
	
func _process(delta: float) -> void:
	super(delta)
	scale = lerp(scale, wanted_scale, delta * 10.0)
	if connected_to && global_position.distance_to(connected_to.global_position) < 10:
		area.set_collision_layer_value(3, true)
	
func select():
	super()
	area.set_collision_layer_value(3, false)
	wanted_scale *= 1.1
	
func deselect():
	super()
	wanted_scale /= 1.1
	material = null
	GlobalAudioStreamPlayer.play_glasshit_sound()
	if connected_to == null:
		area.set_collision_layer_value(3, false)
		position = org_position


func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_selected && area.get_parent().is_in_group("slot"):
		material = outline


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("slot"):
		material = null
