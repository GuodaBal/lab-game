extends "level.gd"

@onready var planter = $Planter as AnimatedSprite2D

func advance(order, used):
	if used >= order.size():
		return
	print_debug(order)
	print_debug(planter.step+1)
	if order.has(planter.step+1):
		planter.next_step()
	else:
		level_complete(false)

func _input(event: InputEvent) -> void:
	if planter.step == 6:
		level_complete(true)
