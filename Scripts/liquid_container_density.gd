extends Sprite2D

@export var density = 1
var drag = 0.05


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#for body in $Area2D.get_overlapping_bodies():
		#var force = body.global_position.y - global_position.y
		#body.gravity_scale = -force/100
		#print_debug(force)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.water = self


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.water = null
