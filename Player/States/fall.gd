@icon( "res://Player/States/state.png" )
class_name PlayerStateFall extends PlayerState



func init() -> void:
	pass
		
	#What happens when we enter this state?
func enter() -> void:
	#play animation
	pass
		
	#What happens when we exit this state?
func exit() -> void:
	pass
	
	#What happens when an input is pressed?
func handle_input( _event : InputEvent) -> PlayerState:
	#handle input
	return next_state


	#What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	
	return next_state
	
	
	#What happens each physics_process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
