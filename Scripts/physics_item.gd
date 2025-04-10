extends RigidBody2D

@export var fits_id = 0
@export var correct_id = 0

var is_selected = false
var click_offset = Vector2(0,0)
var connected_to = null
var initial_gravity = 1.0

func _ready() -> void:
	initial_gravity = gravity_scale

func _physics_process(delta: float) -> void:
	if is_selected:
		var direction = get_global_mouse_position() + click_offset - position
		var target_velocity = (direction*10.0).limit_length(1000)
		set_linear_velocity(lerp(get_linear_velocity(), target_velocity, 0.2))
	if connected_to:
		if position.distance_to(connected_to.position) < 5:
			freeze = true
		else:
			PhysicsServer2D.body_set_state(get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(lerp(position, connected_to.position, delta*50)))
		
func select():
	freeze = false
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = false
	gravity_scale = initial_gravity
	if connected_to:
		connected_to.occupied = false
	connected_to = null
	GlobalVariables.is_mouse_busy = true
	is_selected = true
	click_offset = position - get_global_mouse_position()
	
func deselect():
	GlobalVariables.is_mouse_busy = false
	is_selected = false
	apply_impulse(Vector2(0,0))
	var distances = {}
	if $Area2D:
		for area in $Area2D.get_overlapping_areas():
			var node = area.get_parent()
			if node.is_in_group("slot") && node.fits_id == fits_id && node.occupied == false:
				distances[abs((node.position - position).length())] = node
		if distances.size() > 0:
			var closest = distances.keys().min()
			gravity_scale = 0.0
			connected_to = distances[closest]
			distances[closest].occupied = true
