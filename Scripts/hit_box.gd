extends Area2D
class_name HitBox

var hit: bool = false
@export var damage: int = 10
@export var zeal_meter: ResourceMeter  # drag the player's ResourceMeter node here in the Inspector

func _ready() -> void:
	add_to_group("player_attack")
	set_active(false)

# Enable the hit box when needed
func set_active(state: bool) -> void:
	hit = false
	for child in get_children():
		if child is not CollisionShape2D:
			continue
		child.disabled = not state

func _on_enemy_died() -> void:
	if zeal_meter:
		zeal_meter.on_enemy_killed()
