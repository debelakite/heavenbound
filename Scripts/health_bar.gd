extends TextureRect
class_name HealthStageUI

@export var health_textures: Array[Texture2D] = []
# index 0 = zero health, last index = full health

var current_stage: int = -1  # -1 forces first update to always apply

func _ready() -> void:
	if health_textures.size() > 0:
		current_stage = health_textures.size() - 1
		texture = health_textures[current_stage]

func bind_to_health(health) -> void:
	# health = your player's Health/HealthComponent node, assumed to
	# have current_health, max_health, and a `health_changed` signal.
	_update_from_health(health.current_health, health.max_health)
	health.health_changed.connect(_update_from_health)

func _update_from_health(current: float, max: float) -> void:
	if health_textures.is_empty():
		return
	var percent := current / max if max > 0.0 else 0.0
	var stage_count := health_textures.size()
	var stage: int = clamp(ceil(percent * (stage_count - 1)), 0, stage_count - 1)
	_set_stage(stage)

func _set_stage(stage: int) -> void:
	if stage == current_stage:
		return  # avoid redundant texture swaps
	current_stage = stage
	texture = health_textures[current_stage]
