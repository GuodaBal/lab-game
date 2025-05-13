extends "physics_item.gd"

@onready var On_sprite := $On as Sprite2D
@onready var Off_sprite := $Off as Sprite2D
@onready var area := $Area2D as Area2D
@onready var shadow := $shadow as Sprite2D
@onready var shadow_position := $RayCast2D as RayCast2D
@onready var shadow_on_table := $RayCast2D2 as RayCast2D

@onready var outline = preload("res://Assets/Shaders/outline_material.tres")

var powered = false
var was_snapped := false

var shadow_orig

func _ready() -> void:
	Off_sprite.visible = true
	On_sprite.visible = false
	shadow_orig = shadow.position

func _physics_process(delta: float) -> void:
	super(delta)
	shadow_position.global_rotation = 0
	shadow_on_table.global_rotation = 0
	shadow.global_rotation = 0
	if shadow_position.is_colliding() && !shadow_on_table.is_colliding():
		shadow.global_position = shadow_position.get_collision_point() + Vector2(0, 25)
	else:
		shadow.position = shadow_orig + Vector2(0, 25)
	if is_selected:
		var a = 0
		for slot in area.get_overlapping_areas():
			if slot.get_parent().is_in_group("slot"):
				Off_sprite.material = outline
				a+=1
		if a == 0:
			Off_sprite.material = null
	if connected_to:
		var close_enough = position.distance_to(connected_to.position) < 5
		if close_enough:
			if !was_snapped:
				# Just got placed in
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

func select():
	light_off()
	if connected_to && connected_to.has_wire:
		get_parent().get_parent().turn_off_wires()
	super()

func deselect():
	super()
	Off_sprite.material = null
	if connected_to && connected_to.has_power:
		light()
	else:
		light_off()
	if connected_to && connected_to.has_wire:
		print_debug(connected_to)
		get_parent().get_parent().turn_on_wires()

func light():
	Off_sprite.visible = false
	On_sprite.visible = true
	powered = true

func light_off():
	Off_sprite.visible = true
	On_sprite.visible = false
	powered = false

func refresh():
	await get_tree().process_frame
	if connected_to && connected_to.has_power:
		light()
	else:
		light_off()
