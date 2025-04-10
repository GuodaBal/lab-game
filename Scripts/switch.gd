extends "physics_item.gd"

@onready var sprite_on := $SpriteOn
@onready var sprite_off := $SpriteOff
var closed = false

func _ready() -> void:
	sprite_off.visible = true
	sprite_on.visible = false
	
func _physics_process(delta: float) -> void:
	super(delta)
	if connected_to && position.distance_to(connected_to.position) < 5:
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = true

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
	if connected_to && connected_to.has_wire:
		get_parent().get_parent().turn_off_wires()
	super()
