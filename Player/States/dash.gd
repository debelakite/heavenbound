@icon( "res://Player/States/state.png" )
class_name PlayerStateDash extends PlayerState

@onready var _animation_player = $AnimatedSprite2D

@export var dash_speed: float = 400.0
@export var dash_duration: float = 0.2
var timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO

func init() -> void:
	pass

func enter() -> void:
	timer = dash_duration
	player.ignore_gravity = true
	player.dash_cooldown_timer = player.dash_cooldown

	if player.direction != Vector2.ZERO:
		dash_dir = player.direction.normalized()
	else:
		dash_dir = Vector2(1.0 if player._animation_player.flip_h else -1.0, 0.0)

	player.velocity = dash_dir * dash_speed

func exit() -> void:
	player.ignore_gravity = false
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("attack",true):
		return attack
	return next_state

func process(_delta: float) -> PlayerState:
	timer -= _delta
	if timer <= 0.0:
		return run if player.velocity.x != 0.0 else idle
	return next_state

func physics_process(_delta: float) -> PlayerState:
	return next_state
