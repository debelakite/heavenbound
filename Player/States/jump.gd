@icon( "res://Player/States/state.png" )
class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450.0 #Constant for start jump velocity

	#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	player.velocity.y = -jump.jump_velocity #Cordinate graph has negative y values upwards, to accelarate up flip speed to negative 
	
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( event : InputEvent) -> PlayerState:
	if event.is_action_released( "jump" ): #On release of jump input - slow down upwards movement
		player.velocity.y *= 0.9
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	
	return next_state
	
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.velocity.y >= 0: #If player upwards velocity is over 0 (i.e. falling) go to fall state
		return fall
	return next_state

func took_damage() -> PlayerState:
	return hurt
