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
	print("IDLE running, chase=", enemy.chase)
	# Lost the player -> go back to idle
	if not enemy.chase:
		return idle

	# Apply gravity
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * _delta

	var dir_x = sign(enemy.player.global_position.x - enemy.global_position.x)
	print("dir_x=", dir_x, " ground=", enemy.is_ground_ahead(), " wall=", enemy.is_wall_ahead(), " state=", get_class())
	enemy.update_direction(dir_x > 0)

	if not enemy.is_ground_ahead() or enemy.is_wall_ahead():
		enemy.velocity.x = 0
		enemy.move_and_slide()
		return next_state  #stay in chase
	
	enemy.velocity.x = dir_x * enemy.speed
	enemy.move_and_slide()
	return next_state
