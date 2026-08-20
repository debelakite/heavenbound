@icon("res://Player/States/state.png")
class_name EnemyStateChase extends EnemyState
@export var chase_speed: float = 160.0
@onready var player: Node2D = null

func init() -> void:
	pass

func enter() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> EnemyState:
	return next_state

func process(_delta: float) -> EnemyState:
	return next_state

func physics_process(_delta: float) -> EnemyState:
	if player:
		var x_diff = player.global_position.x - enemy.global_position.x
		enemy.evaluate_facing(x_diff)
		
		if absf(x_diff) > enemy.stop_distance:
			enemy.velocity.x = signf(x_diff) * chase_speed
		else:
			enemy.velocity.x = 0.0
	else:
		enemy.velocity.x = 0.0
	
	if not enemy.chase:
		return idle
	return next_state
