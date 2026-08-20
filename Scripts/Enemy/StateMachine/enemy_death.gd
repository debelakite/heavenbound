@icon( "res://Player/States/state.png" )
class_name EnemyStateDeath extends EnemyState
@export var fallback_death_duration: float = 0.6
var timer: float = 0.0
var used_animation: bool = false

func init() -> void:
	pass

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	if enemy.hitbox_area:
		enemy.hitbox_area.set_deferred("monitoring", false)
	if enemy.player_detection_area:
		enemy.player_detection_area.set_deferred("monitoring", false)
	if enemy.player_lose_area:
		enemy.player_lose_area.set_deferred("monitoring", false)
	
	if enemy.animated_sprite and enemy.animated_sprite.sprite_frames.has_animation("death"):
		used_animation = true
		enemy.animated_sprite.play("death")
		if not enemy.animated_sprite.animation_finished.is_connected(_on_animation_finished):
			enemy.animated_sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	else:
		timer = fallback_death_duration

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> EnemyState:
	return next_state

func process(_delta: float) -> EnemyState:
	return next_state

func physics_process(_delta: float) -> EnemyState:
	if not used_animation:
		timer -= _delta
		if timer <= 0.0:
			enemy.queue_free()
	return next_state

func _on_animation_finished() -> void:
	enemy.queue_free()
