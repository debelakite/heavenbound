@icon( "res://Player/States/state.png" )
class_name EnemyStateChase extends EnemyState

@onready var _animation_player = $AnimatedSprite2D

func init() -> void:
	pass

func enter() -> void:
	#TODO play animation
	pass

func exit() -> void:
	pass

func handle_input( _event : InputEvent) -> EnemyState:
	return next_state

func process( _delta: float ) -> EnemyState:
	return next_state

func physics_process( _delta: float ) -> EnemyState:
	if not enemy.chase:
		return idle

	var x_diff: float = enemy.player.global_position.x - enemy.global_position.x
	enemy.evaluate_facing(x_diff)

	print("x_diff=", x_diff, " facing_right=", enemy.facing_right,
		" ground_ahead=", enemy.is_ground_ahead(), " wall_ahead=", enemy.is_wall_ahead(),
		" wall_check.pos=", enemy.wall_check.position, " ledge_check.pos=", enemy.ledge_check.position)

	if abs(x_diff) <= enemy.stop_distance:
		enemy.velocity.x = 0
	elif not enemy.is_ground_ahead() or enemy.is_wall_ahead():
		enemy.velocity.x = 0
	else:
		enemy.velocity.x = (1.0 if enemy.facing_right else -1.0) * enemy.speed

	return next_state
