extends BossState

var timer: float = 0.0

func enter():
	boss._animation_player.play("Telegraph")
	boss._animation_player.play(boss.current_attack.telegraph_anim)
	timer = boss.current_attack.windup_time

func physics_update(delta):
	timer -= delta
	if timer <= 0.0:
		get_parent().transition_to("Attack")
