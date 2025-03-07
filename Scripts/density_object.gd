extends RigidBody2D

@export var density = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_selected = false
var click_offset = Vector2(0,0)
var reset_state = false
var moveVector: Vector2

var water
var underwater = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if is_selected:
		PhysicsServer2D.body_set_state(get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(get_global_mouse_position()))
		#position = lerp(position, get_global_mouse_position() + click_offset, delta*10)
		#apply_central_force((get_local_mouse_position() + click_offset) * mass * delta * 1000)
		#linear_damp = get_global_mouse_position().distance_to(position)/50
		#apply_central_impulse((get_global_mouse_position() + click_offset - position).normalized() * mass * 2000 * delta)
	#else:
		#linear_damp = 0
	if water != null && position.y < water.position.y:
		underwater = false
	elif water != null:
		underwater = true
		apply_central_force(Vector2(0, water.position.y-position.y*density*2))
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if underwater && water != null:
		state.linear_velocity *= 1 - water.drag
		state.angular_velocity *= 1 - water.drag
	if is_selected:
		pass
		#state.position = get_global_mouse_position()
		#var t = state.get_transform()
		#t.origin.x = get_global_mouse_position().x
		#t.origin.y = get_global_mouse_position().y
		#state.set_transform(t)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") && !GlobalVariables.is_mouse_busy:
		GlobalVariables.is_mouse_busy = true
		is_selected = true
		click_offset = position - get_global_mouse_position()
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("click"):
		GlobalVariables.is_mouse_busy = false
		is_selected = false
		apply_impulse(Vector2(0,0))
