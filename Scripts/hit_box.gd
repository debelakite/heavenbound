extends Area2D
class_name HitBox

var hit: bool = false
const HIT_EFFECT := preload("res://Scenes/HitEffect.tscn")
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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		var owner_enemy = area.owner_enemy
		owner_enemy.take_damage(1, get_parent())
		hit = true
		if zeal_meter:
			zeal_meter.on_hit_landed()
		if owner_enemy.has_signal("died") and not owner_enemy.died.is_connected(_on_enemy_died):
			owner_enemy.died.connect(_on_enemy_died)
		spawn_hit_effect()

func spawn_hit_effect() -> void:
	var fx := HIT_EFFECT.instantiate()
	get_tree().current_scene.add_child(fx)
	fx.global_position = global_position
