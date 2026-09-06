extends Area2D
class_name HitBox

@export var damage: float = 25.0
@export var poise_damage: float = 25.0
var hit: bool = false
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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		var owner_enemy = area.get_parent()
		if owner_enemy is BossController:
			owner_enemy.take_damage(damage, poise_damage)
		else:
			owner_enemy.take_damage(damage, get_parent())
		hit = true
		if zeal_meter:
			zeal_meter.on_hit_landed()
		if owner_enemy.has_signal("died") and not owner_enemy.died.is_connected(_on_enemy_died):
			owner_enemy.died.connect(_on_enemy_died)
