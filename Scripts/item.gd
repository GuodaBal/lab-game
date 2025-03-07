extends Sprite2D

@export var fits_id = 0
@export var correct_id = 0

var is_selected = false
var click_offset = Vector2(0,0)
var connected_to = null



func _process(delta: float) -> void:
	if is_selected:
		position = lerp(position, get_global_mouse_position() + click_offset, delta*10)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") && !GlobalVariables.is_mouse_busy:
		GlobalVariables.is_mouse_busy = true
		is_selected = true
		click_offset = position - get_global_mouse_position()
		if connected_to != null:
			connected_to.occupied = false
		connected_to = null

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("click"):
		GlobalVariables.is_mouse_busy = false
		is_selected = false
		for area in $Area2D.get_overlapping_areas():
			var node = area.get_parent()
			if node.fits_id == fits_id && node.occupied == false:
				print_debug(node)
				position = node.position
				connected_to = node
				node.occupied = true
				break
