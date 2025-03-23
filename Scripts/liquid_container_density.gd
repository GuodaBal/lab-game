extends RigidBody2D

@onready var liquid := $LiquidArea as Area2D
@onready var liquidSprite := $Liquid as Sprite2D

@export var density = 1.0
@export var drag = 0.07
@export var color = "ffff12"
var empty = false

var is_selected = false
var click_offset = Vector2(0,0)
var original_position

func _ready() -> void:
	original_position = position
	liquidSprite.modulate = color
	
	#making liquid shader have different parameters so it's not synced up
	var rndStart = randf_range(0.0, 5.0)
	var liquidMaterial = liquidSprite.material.duplicate()  #create copy so each item has unique material
	liquidSprite.material = liquidMaterial
	liquidSprite.material.set_shader_parameter("random_start", rndStart)
	liquidSprite.material.set_shader_parameter("speed", randf_range(0.5, 2.0))

func _process(delta: float) -> void:
	liquidSprite.material.set_shader_parameter("object_rotation", rotation)
	if is_selected:
		var direction = get_global_mouse_position() - position + click_offset
		var target_velocity = (direction*10.0).limit_length(1000)
		set_linear_velocity(lerp(get_linear_velocity(), target_velocity, 0.1))
		#position = get_global_mouse_position() + click_offset
	if abs(rotation_degrees) > 45 && !empty:
		#Fail if liquid is spilled
		
		empty_container()
		get_parent().level_complete(false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.water = self


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.water = null

func select():
	GlobalVariables.is_mouse_busy = true
	is_selected = true
	click_offset = position - get_global_mouse_position()
	#collision_shape.disabled = true
	liquid.monitoring = false

func deselect():
	GlobalVariables.is_mouse_busy = false
	is_selected = false
	position = original_position
	#collision_shape.disabled = false
	if !empty:
		liquid.monitoring = true

func empty_container():
	liquidSprite.visible = false
	liquid.set_deferred("monitorable", false)
	liquid.set_deferred("monitoring", false)
	empty = true
