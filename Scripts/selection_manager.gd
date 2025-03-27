extends Node2D

@onready var space_state = get_world_2d().direct_space_state  # Get physics space for raycasting
var selected_object = null
var click_start_time = 0.0  # Time when mouse was pressed
var click_threshold = 0.2   # Time limit to detect a click (in seconds)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			click_start_time = Time.get_ticks_msec() / 1000.0  # Store time when clicked
			var clicked_object = find_topmost_object(get_global_mouse_position())
			if clicked_object:
				select_object(clicked_object)
		
		elif not event.pressed and selected_object:
			var click_duration = (Time.get_ticks_msec() / 1000.0) - click_start_time
			if click_duration < click_threshold:
				# If the mouse is released quickly, trigger was_clicked()
				if selected_object.has_method("click"):
					selected_object.click()
			# Release object regardless
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

# Finds the topmost object at the mouse position
func find_topmost_object(mouse_pos):
	var objects = []
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var results = space_state.intersect_point(query, 32)
	
	for result in results:
		var obj = result.collider.get_parent()
		if result.collider is RigidBody2D:
			obj = result.collider
		if obj.is_in_group("draggable_objects"):
			objects.append(obj)

	# Sort by z_index to get the front-most object
	objects.sort_custom(func(a, b): return a.z_index > b.z_index)
	return objects[0] if objects.size() > 0 else null
