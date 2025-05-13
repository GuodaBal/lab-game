extends RigidBody2D

@onready var liquid := $LiquidArea as Area2D
@onready var liquidSprite := $Liquid as Sprite2D
@onready var particles := $CPUParticles2D as CPUParticles2D
@onready var raycast := $RayCast2D as RayCast2D
@onready var shadow := $shadow as Sprite2D

@export var density = 1.0
@export var drag = 0.07
@export var color = "ffff12"
var empty = false

var is_selected = false
var click_offset = Vector2(0,0)
var original_position

func _ready() -> void:
	original_position = position
	liquidSprite.modulate = color
	particles.modulate = color
	contact_monitor = true
	max_contacts_reported = 1  # Max simultaneous contacts you want to track
	
	#making liquid shader have different parameters so it's not synced up
	var rndStart = randf_range(0.0, 5.0)
	var liquidMaterial = liquidSprite.material.duplicate()  #create copy so each item has unique material
	liquidSprite.material = liquidMaterial
	liquidSprite.material.set_shader_parameter("random_start", rndStart)
	liquidSprite.material.set_shader_parameter("speed", randf_range(0.5, 2.0))

func _process(delta: float) -> void:
	raycast.global_rotation = 0
	if raycast.is_colliding():
		shadow.global_position = raycast.get_collision_point() + Vector2(0, -25)
		shadow.global_rotation = 0
	liquidSprite.material.set_shader_parameter("object_rotation", rotation)
	if is_selected:
		var direction = get_global_mouse_position() - position + click_offset
		var target_velocity = (direction*10.0).limit_length(1200)
		set_linear_velocity(lerp(get_linear_velocity(), target_velocity, 0.3))
	if abs(rotation_degrees) > 45 && !empty:
		#Fail if liquid is spilled
		empty_container()
		get_parent().level_complete(false)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.water = self
	particles.emitting = true
	GlobalAudioStreamPlayer.play_splash_sound()
	print_debug(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.water = null

func select():
	GlobalVariables.is_mouse_busy = true
	is_selected = true
	click_offset = position - get_global_mouse_position()

func deselect():
	GlobalVariables.is_mouse_busy = false
	is_selected = false
	position = original_position

func empty_container():
	liquidSprite.visible = false
	liquid.set_deferred("monitorable", false)
	liquid.set_deferred("monitoring", false)
	GlobalAudioStreamPlayer.play_pour_sound()
	empty = true
	shadow.modulate = "ffffff2c"

var has_collided := false
var last_sound_time := 0.0

var current_colliders := []
const SOUND_COOLDOWN := 0.7  # seconds

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var now = Time.get_ticks_msec() / 1000.0
	var new_colliders := []

	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)

		if collider:
			# Only play sound if it's a new contact AND cooldown has passed
			if collider not in current_colliders and now - last_sound_time >= SOUND_COOLDOWN:
				GlobalAudioStreamPlayer.play_glasshit_sound()
				last_sound_time = now

			new_colliders.append(collider)

	current_colliders = new_colliders
