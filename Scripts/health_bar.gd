extends TextureRect
class_name HealthStageUI

@export var health_textures: Array[Texture2D] = []
# index 0 = zero health, last index = full health

var current_stage: int = -1  # -1 forces first update to always apply

func _ready() -> void:
	if health_textures.size() > 0:
		current_stage = health_textures.size() - 1
		texture = health_textures[current_stage]

func bind_to_health(player) -> void:
	# player = your player node, assumed to have `health_stage`
	# and a `health_changed(stage: int)` signal
	print("binding, initial stage: ", player.health_stage)
	_set_stage(player.health_stage)
	player.health_changed.connect(_set_stage)

func _set_stage(stage: int) -> void:
	print("_set_stage got: ", stage, " | current_stage: ", current_stage, " | array size: ", health_textures.size())
	if stage == current_stage:
		return
	current_stage = stage
	texture = health_textures[current_stage]
