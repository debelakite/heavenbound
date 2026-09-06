# BossAttackState.gd
extends BossState

const PROJECTILE = preload("res://BossOne/SpearProjectile.tscn")
var timer: float = 0.0

func enter():
	boss._animation_player.play(boss.current_attack.attack_anim)
	boss.hitbox_area.monitoring = true
	boss.last_attack_name = boss.current_attack.name
	var proj = PROJECTILE.instantiate()
	get_tree().current_scene.add_child(proj)
	proj.global_position = boss.global_position
	proj.direction = (get_player_pos() - boss.global_position).normalized()
	timer = boss.current_attack.active_time
	timer = boss.current_attack.active_time

func exit():
	boss.hitbox_area.monitoring = false

func physics_update(delta: float):
	timer -= delta
	if timer <= 0.0:
		get_parent().transition_to("Recover")

func handle_hit(damage: float, poise_damage: float):
	boss.current_hp -= damage
	boss.poise -= poise_damage
	if boss.poise <= 0.0:
		get_parent().transition_to("Staggered")


func get_player_pos() -> Vector2:
	return get_tree().get_first_node_in_group("player").global_position
