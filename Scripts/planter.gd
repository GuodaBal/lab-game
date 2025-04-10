extends AnimatedSprite2D

@onready var flower_animation = $AnimatedSprite2D as AnimatedSprite2D

var step = 0

func _ready() -> void:
	flower_animation.visible = false
	play("0")

func next_step():
	step += 1
	if step == 1:
		play("1")
	if step == 3:
		flower_animation.visible = true
	if step == 6:
		flower_animation.play("grow")
