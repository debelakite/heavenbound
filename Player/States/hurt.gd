@icon( "res://Player/States/state.png" )
class_name PlayerStateHurt extends PlayerState

var hurt_timer = 0
#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	if player.velocity.x != 0: #Propel player oposite direction, or if player is not moving, just go left
		player.velocity.x = -(player.velocity.x/abs(player.velocity.x))*200
	else:
		player.velocity.x = -200
	player.velocity.y = -450 #Propel player up upon taking damage
	
		
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	if _event:
		return next_state
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	hurt_timer += _delta
	if hurt_timer > 1:
		hurt_timer = 0
		return fall
	return next_state
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> PlayerState:

	return next_state
	
func took_damage() -> PlayerState: #If player has taken damage, remain in hurt state
	return next_state
