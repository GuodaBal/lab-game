extends "physics_item.gd"

@onready var sprite_on := $SpriteOn
@onready var sprite_off := $SpriteOff
@onready var area := $Area2D as Area2D
@onready var shadow := $shadow as Sprite2D
@onready var shadow_position := $RayCast2D as RayCast2D
@onready var shadow_on_table := $RayCast2D2 as RayCast2D

@onready var outline = preload("res://Assets/Shaders/outline_material.tres")

var shadow_orig

var closed = false
func _ready() -> void:
	sprite_off.visible = true
	sprite_on.visible = false
	shadow_orig = shadow.position
	
func _physics_process(delta: float) -> void:
	super(delta)
	shadow_position.global_rotation = 0
	shadow_on_table.global_rotation = 0
	shadow.global_rotation = 0
	if !shadow_on_table.is_colliding():
		shadow.global_position = shadow_position.get_collision_point() + Vector2(0, 25)
	else:
		shadow.position = shadow_orig + Vector2(0, 25)
	if connected_to && position.distance_to(connected_to.position) < 5:
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = true
	if is_selected:
		var a = 0
		for slot in area.get_overlapping_areas():
			if slot.get_parent().is_in_group("slot"):
				sprite_on.material = outline
				sprite_off.material = outline
				a+=1
		if a == 0:
			sprite_on.material = null
			sprite_off.material = null
				



func click():
	closed = !closed
	if closed:
		GlobalAudioStreamPlayer.play_switch_sound()
		sprite_off.visible = false
		sprite_on.visible = true
		if connected_to && connected_to.has_wire:
			get_parent().get_parent().turn_on_wires()
	else:
		GlobalAudioStreamPlayer.play_switch_sound()
		sprite_off.visible = true
		sprite_on.visible = false
		if connected_to && connected_to.has_wire:
			get_parent().get_parent().turn_off_wires()

func deselect():
	super()
	if connected_to && connected_to.has_wire && closed:
		get_parent().get_parent().turn_on_wires()

func select():
	sprite_on.material = null
	sprite_off.material = null
	if connected_to && connected_to.has_wire:
		get_parent().get_parent().turn_off_wires()
	super()


func _on_area_2d_mouse_entered() -> void:
	sprite_on.material = outline
	sprite_off.material = outline


func _on_area_2d_mouse_exited() -> void:
	sprite_on.material = null
	sprite_off.material = null
