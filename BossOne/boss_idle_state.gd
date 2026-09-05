# BossIdleState.gd
extends BossState

@export var idle_duration: float = 0.5

var timer: float = 0.0

func enter():
	timer = idle_duration
	boss.animation_player.play("idle")
	boss.hitbox_area.monitoring = false

func physics_update(delta: float):
	timer -= delta
	if timer <= 0.0:
		get_parent().transition_to("Decide")

func handle_hit(damage: float, poise_damage: float):
	boss.current_hp -= damage
	boss.poise -= poise_damage
	if boss.poise <= 0.0:
		get_parent().transition_to("Staggered")
