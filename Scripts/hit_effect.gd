extends GPUParticles2D

func _ready() -> void:
	finished.connect(queue_free)
	emitting = true

func _on_finished() -> void:
	queue_free()
