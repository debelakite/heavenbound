@icon( "res://Player/States/state.png" )
class_name PlayerStateIdle extends PlayerState


	#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	pass
		
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("attack"):
		hit_box.set_active(true)
		return attack
	elif _event.is_action_pressed("jump",true): #On jump input - enter jump state
		return jump
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	if player.direction.x != 0 && player.is_on_floor(): #If player is on floor and moving horizantelly, enter run state
		return run
	return next_state
	
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false: #If player is not on floor and is in an idle state, enter fall state
		return fall
	return next_state

func took_damage() -> PlayerState: #If player has taken damage go to hurt state
	return hurt
