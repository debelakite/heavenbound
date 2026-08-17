@icon( "res://Player/States/state.png" )
class_name EnemyStateIdle extends EnemyState

@onready var _animation_player = $AnimatedSprite2D

	#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	enemy.velocity.x = 0
	#TODO play animation
	#_animation_player.play("Idle")
	pass
		
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> EnemyState:
	
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> EnemyState:
	
	return next_state
	
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> EnemyState:
	print("Idle physics_process running, chase = ", enemy.chase)
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * _delta
	enemy.move_and_slide()
	
	if enemy.chase:
		return chase
	return next_state
