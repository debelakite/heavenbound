@icon( "res://Player/States/state.png" )
class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450.0


func init() -> void:
	pass
		
	#What happens when we enter this state?
func enter() -> void:
	#play animation
	player.velocity.y = -jump.jump_velocity

		
	#What happens when we exit this state?
func exit() -> void:
	pass
	
	#What happens when an input is pressed?
func handle_input( event : InputEvent) -> PlayerState:
	if event.is_action_released( "jump" ):
		player.velocity.y *= 0.9
		#return fall
	return next_state


	#What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	
	return next_state
	
	
	#What happens each physics_process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.velocity.y >= 0:
		return fall
	return next_state
