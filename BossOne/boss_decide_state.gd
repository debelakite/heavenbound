# BossDecideState.gd
extends BossState

func enter():
	# check for phase transition first
	if boss.hp_percent() <= boss.phase_thresholds[boss.phase] and boss.phase < boss.max_phase:
		get_parent().transition_to("PhaseTransition")
		return

	var pool = _get_valid_attacks()

	if pool.is_empty():
		# nothing usable right now (out of range / all on cooldown) - wait a beat
		get_parent().transition_to("Idle")
		return

	var chosen: AttackData = _weighted_pick(pool)
	boss.current_attack = chosen
	boss.cooldowns[chosen.name] = chosen.cooldown
	get_parent().transition_to("Telegraph")

func physics_update(delta: float):
	pass # decide is instantaneous - all logic runs in enter()

func _get_valid_attacks() -> Array[AttackData]:
	var dist = boss.dist_to_player()
	var pool: Array[AttackData] = []
	for attack in boss.attack_pools[boss.phase]:
		if attack.max_range < dist:
			continue
		if boss.cooldowns.get(attack.name, 0.0) > 0.0:
			continue
		pool.append(attack)
	return pool

func _weighted_pick(pool: Array[AttackData]) -> AttackData:
	# avoid repeating the same attack twice in a row when alternatives exist
	var filtered = pool.filter(func(a): return a.name != boss.last_attack_name)
	var final_pool = filtered if not filtered.is_empty() else pool
	return final_pool[randi() % final_pool.size()]
