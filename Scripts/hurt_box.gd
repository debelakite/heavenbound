extends Area2D
class_name HurtBox

const HIT_EFFECT := preload("res://Scenes/HitEffect.tscn")

@export var owner_enemy: Enemy

func _ready() -> void:
	if owner_enemy == null:
		owner_enemy = get_parent() as Enemy
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		owner_enemy.take_damage(1, area.get_parent())
		if area is HitBox:
			area.hit = true
		spawn_hit_effect()

func spawn_hit_effect() -> void:
	var fx := HIT_EFFECT.instantiate()
	get_tree().current_scene.add_child(fx)
	fx.global_position = global_position
