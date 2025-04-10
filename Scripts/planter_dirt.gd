extends Sprite2D

@export var order : Array[int] = []

var org_position
var is_selected = false
var click_offset = Vector2(0,0)
var used = 0


func use():
	used += 1

func select():
	GlobalVariables.is_mouse_busy = true
	is_selected = true
	click_offset = position - get_global_mouse_position()
	
func deselect():
	GlobalVariables.is_mouse_busy = false
	is_selected = false
	position = org_position
	get_parent().advance(order, used)
