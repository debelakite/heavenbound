extends TextureRect

@export var health_textures: Array[Texture2D] = []
# Fill this array in the Inspector with 5 images, in order:
# index 0 = zero health, index 4 = full health

var current_stage: int = 4  # starts at full health

func _ready() -> void:
	update_health_display()

func set_health_stage(stage: int) -> void:
	current_stage = clamp(stage, 0, health_textures.size() - 1)
	update_health_display()

func update_health_display() -> void:
	if health_textures.size() > 0:
		texture = health_textures[current_stage]
