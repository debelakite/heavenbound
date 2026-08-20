@icon( "res://Player/States/state.png" )
class_name EnemyStateHurt extends EnemyState
@export var hurt_duration: float = 0.3
@export var knockback_force: float = 220.0
@export var knockback_up_force: float = 80.0
@export var knockback_decel: float = 600.0
var timer: float = 0.0

func init() -> void:
	pass

func enter() -> void:
	timer = hurt_duration
	var dir: float = enemy.pending_knockback_dir
	enemy.velocity.x = dir * knockback_force
	enemy.velocity.y = -knockback_up_force
	if enemy.animated_sprite and enemy.animated_sprite.sprite_frames.has_animation("hurt"):
		enemy.animated_sprite.play("hurt")

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> EnemyState:
	return next_state

func process(_delta: float) -> EnemyState:
	return next_state

func physics_process(_delta: float) -> EnemyState:
	timer -= _delta
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, knockback_decel * _delta)
	
	if enemy.is_dead:
		return death
	if timer <= 0.0:
		return chase if enemy.chase else idle
	return next_state
