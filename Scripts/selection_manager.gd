extends Node2D

@onready var space_state = get_world_2d().direct_space_state  # Get physics space for raycasting
var selected_object = null

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		var clicked_object = find_topmost_object(get_global_mouse_position())
		if clicked_object:
			select_object(clicked_object)

	elif event is InputEventMouseButton and not event.pressed:
		if selected_object:
			release_object()
			
func select_object(obj):
	if selected_object:
		selected_object.deselect()  # Deselect previous object
	selected_object = obj
	selected_object.select()

func release_object():
	if selected_object:
		selected_object.deselect()
		selected_object = null

#Finds what object is visually on the top
func find_topmost_object(mouse_pos):
	var objects = []
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true  # Include Area2D objects
	query.collide_with_bodies = true  # Include RigidBody2D, StaticBody2D, etc.
	
	var results = space_state.intersect_point(query, 32)  # Max 32 results for safety
	
	for result in results:
		var obj = result.collider.get_parent()
		if result.collider is RigidBody2D:
			obj = result.collider
		if obj.is_in_group("draggable_objects"):
			objects.append(obj)
	# Sort by z_index to get the front-most object
	objects.sort_custom(func(a, b): return a.z_index > b.z_index)
	return objects[0] if objects.size() > 0 else null
