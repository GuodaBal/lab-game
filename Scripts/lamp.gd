extends "item.gd"

func _ready() -> void:
	$PointLight2D.visible = false


func deselect():
	super()
	if connected_to && connected_to.has_wire:
		$PointLight2D.visible = true
