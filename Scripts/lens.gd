extends "item.gd"

@export var bending_degrees = 0

@onready var area = $Area2D as Area2D

var org_position

func _ready() -> void:
	org_position = global_position
	area.set_collision_layer_value(3, false)
	
func _process(delta: float) -> void:
	super(delta)
	if connected_to && global_position.distance_to(connected_to.global_position) < 10:
		area.set_collision_layer_value(3, true)
	
func select():
	super()
	area.set_collision_layer_value(3, false)
	
func deselect():
	super()
	GlobalAudioStreamPlayer.play_glasshit_sound()
	if connected_to == null:
		area.set_collision_layer_value(3, false)
		position = org_position
