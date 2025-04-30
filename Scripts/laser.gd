extends Node2D

@onready var raycast := $RayCast2D as RayCast2D
@onready var line := $Line2D as Line2D

@export var intensity = 1.0

func _ready() -> void:
	update()

func _process(delta: float) -> void:
	update()
#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("click") || Input.is_action_just_released("click"):
		#update()

func update():
	raycast.global_position = position
	raycast.rotation = 0
	line.clear_points()
	line.add_point(line.to_local(raycast.global_position))
	raycast.force_raycast_update()

	var previous_collision_point = raycast.global_position

	while raycast.is_colliding():
		var current_collision_point = raycast.get_collision_point()
		var local_col = line.to_local(current_collision_point)
		line.add_point(local_col)

		# Calculate actual direction the ray is traveling
		var incoming_dir = (current_collision_point - previous_collision_point).normalized()


		# Get bending data
		var collider = raycast.get_collider().get_parent()
		var bend_angle = collider.bending_degrees * intensity

		# Rotate incoming direction by bend angle
		var new_dir = incoming_dir.rotated(deg_to_rad(bend_angle)).normalized()

		# Advance raycast along new direction
		raycast.global_position = current_collision_point + new_dir * 2
		previous_collision_point = current_collision_point

		# Optional: update raycast rotation for visual/debug purposes
		raycast.rotation = new_dir.angle()

		raycast.force_raycast_update()
		# await get_tree().create_timer(0.02).timeout  # Uncomment if needed for frame sync
		#print_debug("Ray rotation (deg): ", rad2deg(raycast.rotation))

	# Final extended ray
	var final_dir = Vector2(cos(raycast.rotation), sin(raycast.rotation)).normalized() * 3000
	line.add_point(line.to_local(raycast.global_position + final_dir))

	
	
