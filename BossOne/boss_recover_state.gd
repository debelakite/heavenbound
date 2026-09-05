# BossRecoverState.gd
extends BossState

@export var recover_duration_fallback: float = 0.8

var timer: float = 0.0

func enter():
	boss.animation_player.play("recover")
	boss.hitbox_area.monitoring = false
	timer = boss.current_attack.recover_time if boss.current_attack else recover_duration_fallback

func physics_update(delta: float):
	timer -= delta
	if timer <= 0.0:
		get_parent().transition_to("Decide")

func handle_hit(damage: float, poise_damage: float):
	# recover is the player's punish window - no poise resistance bonus here
	boss.current_hp -= damage
	boss.poise -= poise_damage
	if boss.poise <= 0.0:
		get_parent().transition_to("Staggered")
