# BossDeadState.gd
extends BossState

func enter():
	boss._animation_player.play("Death")
	boss.hitbox_area.monitoring = false
	boss.hurtbox_area.monitoring = false
	boss.set_physics_process(false)
	boss.died.emit()

func physics_update(delta: float):
	pass  # dead - nothing to update

func handle_hit(damage: float, poise_damage: float):
	pass  # already dead - ignore further hits
