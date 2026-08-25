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
		enemy.evaluate_facing(enemy.x_diff)
		
		if absf(enemy.x_diff) > enemy.stop_distance:
			enemy.velocity.x = signf(enemy.x_diff) * chase_speed
			#print("Enemy velocity: ", enemy.velocity.x)
		else:
			enemy.velocity.x = 0.0
			#print("Enemy has stopped chasing due to reaching stop distance")
	else:
		enemy.velocity.x = 0.0
	
	if not enemy.chase:
		return idle
	return next_state
