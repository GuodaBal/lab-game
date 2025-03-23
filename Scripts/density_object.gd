extends RigidBody2D

@export var density = 1.0
var floating_power

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var collision_shape := $CollisionShape2D as CollisionShape2D

var is_selected = false
var click_offset = Vector2(0,0)
var reset_state = false
var moveVector: Vector2

var water
var underwater = false

func _physics_process(delta: float) -> void:
	if is_selected:
		var direction = get_global_mouse_position() - position
		var target_velocity = (direction*10.0).limit_length(1000)
		set_linear_velocity(lerp(get_linear_velocity(), target_velocity, 0.2))
		#PhysicsServer2D.body_set_state(get_rid(),
		#PhysicsServer2D.BODY_STATE_TRANSFORM,
		#Transform2D.IDENTITY.translated(get_global_mouse_position()))
		
	if water != null:
		set_collision_mask_value(3, true)
		if position.y < water.position.y:
			underwater = false
		else:
			underwater = true
			if density > water.density:
				floating_power = 1.0
			else:
				floating_power = 2.0
			apply_central_force(Vector2(0, water.position.y-position.y*floating_power))
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if underwater && water != null:
		state.linear_velocity *= 1 - water.drag
		state.angular_velocity *= 1 - water.drag


func select():
	#print_debug("selecting")
	GlobalVariables.is_mouse_busy = true
	is_selected = true
	click_offset = position - get_global_mouse_position()
	#collision_shape.disabled = true
	
func deselect():
	GlobalVariables.is_mouse_busy = false
	is_selected = false
	apply_impulse(Vector2(0,0))
	#collision_shape.disabled = false
