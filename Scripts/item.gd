extends Sprite2D

@export var fits_id = 0
@export var correct_id = 0

var is_selected = false
var click_offset = Vector2(0,0)
var connected_to = null

func _process(delta: float) -> void:
	if is_selected:
		GlobalAudioStreamPlayer.play_place_sound()
		position = lerp(position, get_global_mouse_position() + click_offset, delta*10)
	if connected_to:
		position = lerp(position, connected_to.position, delta*10)


func select():
	GlobalVariables.is_mouse_busy = true
	is_selected = true
	click_offset = position - get_global_mouse_position()
	if connected_to != null:
		connected_to.occupied = false
	connected_to = null
	
func deselect():
	GlobalVariables.is_mouse_busy = false
	is_selected = false
	for area in $Area2D.get_overlapping_areas():
		var node = area.get_parent()
		if node.fits_id == fits_id && node.occupied == false:
			connected_to = node
			node.occupied = true
			break
