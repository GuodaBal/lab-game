extends "physics_item.gd"

@onready var sprite := $battery as Sprite2D
@onready var area := $Area2D as Area2D
@onready var shadow := $shadow as Sprite2D
@onready var shadow_position := $RayCast2D as RayCast2D
@onready var shadow_on_table := $RayCast2D2 as RayCast2D

@onready var outline = preload("res://Assets/Shaders/outline_material.tres")

var shadow_orig

func _ready() -> void:
	super()
	shadow_orig = shadow.position

func select():
	if connected_to && connected_to.has_wire:
		connected_to.depower_connections()
		if connected_to.can_be_powered:
			connected_to.depowered_from_item()
	super()
	
var was_snapped := false

func _physics_process(delta: float) -> void:
	super(delta)
	shadow_position.global_rotation = 0
	shadow_on_table.global_rotation = 0
	shadow.global_rotation = 0
	if !shadow_on_table.is_colliding():
		shadow.global_position = shadow_position.get_collision_point() + Vector2(0, 25)
	else:
		shadow.position = shadow_orig + Vector2(0, 25)
	if is_selected:
		var a = 0
		for slot in area.get_overlapping_areas():
			if slot.get_parent().is_in_group("slot"):
				sprite.material = outline
				a+=1
		if a == 0:
			sprite.material = null
	if connected_to:
		var close_enough = position.distance_to(connected_to.position) < 5

		if close_enough:
			if !was_snapped:
				# Just got placed in!
				GlobalAudioStreamPlayer.play_place_sound()
				was_snapped = true

				for child in get_children():
					if child is CollisionShape2D:
						child.disabled = true

			# Lock it in place
			freeze = true
		else:
			# Item was moved away from slot
			was_snapped = false
			freeze = false
	else:
		was_snapped = false  # No connection = can't be snapped
				

func deselect():
	super()
	sprite.material = null
	if connected_to && connected_to.has_wire:
		get_parent().get_parent().turn_on_wires()
		#if connected_to.wire_connected_to.size() > 1:
			#connected_to.power_connections()
			#if !connected_to.can_be_powered:
				#connected_to.powered_from_item()
			
func refresh():
	if connected_to && connected_to.has_wire:
		get_parent().get_parent().turn_off_wires()
		#connected_to.depower_connections()
		#await get_tree().process_frame
		#if connected_to && connected_to.has_wire:
			#connected_to.power_connections()
