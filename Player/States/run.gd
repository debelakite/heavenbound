@icon( "res://Player/States/state.png" )
class_name PlayerStateRun extends PlayerState



func init() -> void:
	pass
		
	#What happens when we enter this state?
func enter() -> void:
	pass
		
	#What happens when we exit this state?
func exit() -> void:
	pass
	
	#What happens when an input is pressed?
func handle_input( _event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	return next_state


	#What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.direction.x == 0:
		return idle
	return next_state
	
	
	#What happens each physics_process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false:
		return fall
	return next_state
