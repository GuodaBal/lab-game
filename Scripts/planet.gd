extends "physics_item.gd"

@onready var outline = preload("res://Assets/Shaders/outline_material.tres")
@onready var spark = preload("res://Scenes/spark_particle.tscn")
@onready var sprite = $Sprite2D as Sprite2D

@export var line_thickness_adj = 4.562
@export var blur_strength_adj = 0.384

func _ready() -> void:
	super()
	outline = outline.duplicate()
	outline.set_shader_parameter("scale", sprite.scale.x)
	outline.set_shader_parameter("line_thickness", line_thickness_adj)
	outline.set_shader_parameter("blur_strength", blur_strength_adj)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("slot") && is_selected:
		sprite.material = outline


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("slot"):
		sprite.material = null
		
func deselect():
	super()
	sprite.material = null
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	for i in state.get_contact_count():
		var pos := state.get_contact_local_position(i)
		var particles := spark.instantiate() as CPUParticles2D
		get_tree().current_scene.add_child(particles)
		particles.set_deferred("global_position", pos)
		particles.set_deferred("z_index", 0)

func spawn_spark(pos):
	var particles := spark.instantiate() as CPUParticles2D
	get_tree().current_scene.add_child(particles)
	particles.set_deferred("global_position", pos)
	particles.set_deferred("z_index", 0)
