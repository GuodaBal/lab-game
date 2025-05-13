extends AnimatedSprite2D

@onready var outline = preload("res://Assets/Shaders/outline_material.tres")
@export var order : Array[int] = []
var used = 0
var on = false

func _ready() -> void:
	outline = outline.duplicate()
	outline.set_shader_parameter("line_thickness", 10.0)
	outline.set_shader_parameter("blur_strength", 0.4)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if used == 1:
		return
	if Input.is_action_just_pressed("click"):
		on = true
		play("on")
		get_parent().advance(order, used)


func _on_area_2d_mouse_entered() -> void:
	material = outline


func _on_area_2d_mouse_exited() -> void:
	material = null
