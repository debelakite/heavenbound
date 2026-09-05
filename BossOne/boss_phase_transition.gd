# BossPhaseTransitionState.gd
extends BossState

@export var transition_duration: float = 1.5
@export var invincible_during_transition: bool = true

var timer: float = 0.0

func enter():
	timer = transition_duration
	boss.phase += 1
	boss._animation_player.play("phase_transition_" + str(boss.phase))
	boss.hitbox_area.monitoring = false

	if invincible_during_transition:
		boss.hurtbox_area.monitoring = false

	# clear cooldowns so the new phase's kit is immediately available
	boss.cooldowns.clear()
	boss.last_attack_name = ""

	_on_phase_entered(boss.phase)

func exit():
	if invincible_during_transition:
		boss.hurtbox_area.monitoring = true

func physics_update(delta: float):
	timer -= delta
	if timer <= 0.0:
		get_parent().transition_to("Decide")

func handle_hit(damage: float, poise_damage: float):
	pass # invincible - hits during transition do nothing (hurtbox is off anyway if enabled)

func _on_phase_entered(new_phase: int):
	# hook for phase-specific one-offs: arena hazards, VFX, camera shake, music swap, etc.
	match new_phase:
		2:
			pass # e.g. boss.get_node("ArenaHazards").activate()
		3:
			pass # e.g. desperation phase VFX
