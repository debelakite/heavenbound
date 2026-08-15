@icon( "res://Player/States/state.png" )
class_name PlayerStateRun extends PlayerState

	#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	pass
		
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("attack"):
		return attack
	elif _event.is_action_pressed("jump",true): #On jump input - enter jump state
		return jump
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	if player.direction.x == 0 && player.is_on_floor(): #If player on floor and not moving, enter idle state
		return idle
	return next_state
	
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false: #If player not on floor but running, enter fall state
		return fall
	return next_state

func took_damage() -> PlayerState: #If player has taken damage, go to hurt state
	return hurt
