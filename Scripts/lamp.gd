extends "physics_item.gd"

@onready var On_sprite := $On as Sprite2D
@onready var Off_sprite := $Off as Sprite2D

var powered = false
var was_snapped := false
func _ready() -> void:
	Off_sprite.visible = true
	On_sprite.visible = false

func _physics_process(delta: float) -> void:
	super(delta)

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
	print_debug(connected_to)
	if connected_to && connected_to.has_wire:
		get_parent().get_parent().turn_off_wires()
	super()

func deselect():
	super()
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
