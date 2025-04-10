extends Sprite2D

@export var order : Array[int] = []

@onready var area := $Area2D as Area2D

var org_position
var is_selected = false
var click_offset = Vector2(0,0)
var used = 0


func _ready() -> void:
	org_position = position
	

func _process(delta: float) -> void:
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
