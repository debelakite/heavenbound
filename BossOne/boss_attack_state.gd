# BossAttackState.gd
extends BossState

var timer: float = 0.0

func enter():
	boss._animation_player.play(boss.current_attack.attack_anim)
	boss.hitbox_area.monitoring = true
	boss.last_attack_name = boss.current_attack.name
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
