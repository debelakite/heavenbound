extends Area2D
class_name HurtBox

const HIT_EFFECT := preload("res://Scenes/HitEffect.tscn")

@export var owner_enemy: Enemy
@export var damage: int = 1

func _ready() -> void:
	add_to_group("enemy_hurtbox")
	if owner_enemy == null:
		owner_enemy = get_parent() as Enemy

func _physics_process(_delta: float) -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("player_hurtbox"):
			_deal_damage_to(area)

func _deal_damage_to(area: Area2D) -> void:
	var player = area.owner_player
	if player and not player.is_invincible:
		player.take_damage(damage, get_parent())
		spawn_hit_effect()

func spawn_hit_effect() -> void:
	var fx := HIT_EFFECT.instantiate()
	get_tree().current_scene.add_child(fx)
	fx.global_position = global_position
