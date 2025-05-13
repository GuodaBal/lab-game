extends Sprite2D

@export var order : Array[int] = []
@onready var outline = preload("res://Assets/Shaders/outline_material.tres")
@onready var area := $Area2D as Area2D

@onready var shadow := $shadow as Sprite2D
@onready var shadow_position := $RayCast2D as RayCast2D
@onready var shadow_on_table := $RayCast2D2 as RayCast2D

var org_position
var is_selected = false
var click_offset = Vector2(0,0)
var used = 0

var shadow_orig


func _ready() -> void:
	org_position = position
	outline = outline.duplicate()
	outline.set_shader_parameter("line_thickness", 10.0)
	outline.set_shader_parameter("blur_strength", 0.4)
	shadow_orig = shadow.position
	

func _process(delta: float) -> void:
	shadow_position.global_rotation = 0
	shadow_on_table.global_rotation = 0
	shadow.global_rotation = 0
	if !shadow_on_table.is_colliding():
		shadow.global_position = shadow_position.get_collision_point() + Vector2(0, 45)
	else:
		shadow.position = shadow_orig + Vector2(0, 45)
	if is_selected:
		GlobalAudioStreamPlayer.play_place_sound()
		position = lerp(position, get_global_mouse_position() + click_offset, delta*10)

func select():
	GlobalVariables.is_mouse_busy = true
	is_selected = true
	click_offset = position - get_global_mouse_position()
	
func deselect():
	GlobalVariables.is_mouse_busy = false
	is_selected = false
	position = org_position
	for area in area.get_overlapping_areas():
		if area.get_parent().is_in_group("planter"):
			get_parent().advance(order, used)
			used += 1
			
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("planter") && is_selected:
		material = outline


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("planter"):
		material = null
