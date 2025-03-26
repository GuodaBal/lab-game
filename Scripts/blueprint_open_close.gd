extends Node2D

var open = false
@onready var opened_blueprint := $Opened as Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opened_blueprint.visible = false


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		opened_blueprint.visible = !opened_blueprint.visible
