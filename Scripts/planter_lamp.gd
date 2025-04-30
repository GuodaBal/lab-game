extends AnimatedSprite2D

@export var order : Array[int] = []
var used = 0
var on = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if used == 1:
		return
	if Input.is_action_just_pressed("click"):
		on = true
		play("on")
		get_parent().advance(order, used)
