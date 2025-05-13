extends CPUParticles2D

func _ready() -> void:
	emitting = true

func finished():
	queue_free()
