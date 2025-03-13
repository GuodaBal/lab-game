extends StaticBody2D

@onready var collision_shape := $CollisionPolygon2D as CollisionPolygon2D
@onready var liquid := $LiquidArea as Area2D

@export var density = 1.0
@export var drag = 0.07
@export var color = "ffff12"
var empty = false

var is_selected = false
var click_offset = Vector2(0,0)
var original_position

func _ready() -> void:
	original_position = position
	$Sprite.modulate = color

func _process(delta: float) -> void:
	if is_selected:
		position = get_global_mouse_position() + click_offset


func _on_area_2d_body_entered(body: Node2D) -> void:
	print_debug(liquid.monitoring)
	body.water = self


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.water = null

func select():
	GlobalVariables.is_mouse_busy = true
	is_selected = true
	click_offset = position - get_global_mouse_position()
	collision_shape.disabled = true
	liquid.monitoring = false

func deselect():
	GlobalVariables.is_mouse_busy = false
	is_selected = false
	position = original_position
	collision_shape.disabled = false
	if !empty:
		liquid.monitoring = true

func empty_container():
	print_debug("emptied")
	$Sprite.visible = false
	
	liquid.set_deferred("monitorable", false)
	liquid.set_deferred("monitoring", false)
	print_debug(liquid.monitorable)
	empty = true
