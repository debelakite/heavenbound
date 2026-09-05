# BossStaggeredState.gd
extends BossState

@export var stagger_duration: float = 2.0

var timer: float = 0.0

func enter():
	timer = stagger_duration
	boss.animation_player.play("stagger")
	boss.hitbox_area.monitoring = false
	boss.poise = boss.max_poise   # refill poise so it isn't immediately re-triggered

func physics_update(delta: float):
	timer -= delta
	if timer <= 0.0:
		get_parent().transition_to("Decide")

func handle_hit(damage: float, poise_damage: float):
	# boss is defenseless here - full damage, no poise check needed since already staggered
	boss.current_hp -= damage
