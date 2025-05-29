extends "level.gd"

@onready var planter = $Planter as AnimatedSprite2D

func advance(order, used):
	if used >= order.size():
		return
	if order.has(planter.step+1):
		planter.next_step()
	else:
		level_complete(false)

func _input(event: InputEvent) -> void:
	super(event)
	if planter.step == 6:
		await planter.get_child(0).animation_finished
		level_complete(true)
