extends Area2D
class_name HurtBox

const HIT_EFFECT := preload("res://Scenes/HitEffect.tscn")
@export var owner_enemy: Enemy

func _ready() -> void:
	add_to_group("enemy_hurtbox")
	if owner_enemy == null:
		owner_enemy = get_parent() as Enemy
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		owner_enemy.take_damage(1, area.get_parent())
		if area is HitBox:
			area.hit = true
			if area.zeal_meter:
				area.zeal_meter.on_hit_landed()
			if owner_enemy.has_signal("died") and not owner_enemy.died.is_connected(area._on_enemy_died):
				owner_enemy.died.connect(area._on_enemy_died)
		spawn_hit_effect()

func spawn_hit_effect() -> void:
	var fx := HIT_EFFECT.instantiate()
	get_tree().current_scene.add_child(fx)
	fx.global_position = global_position
