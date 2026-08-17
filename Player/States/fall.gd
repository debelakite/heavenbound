@icon( "res://Player/States/state.png" )
class_name PlayerStateFall extends PlayerState

@onready var _animation_player = $AnimatedSprite2D

	#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	player._animation_player.play("Fall")
	pass
		
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("attack"):
		return attack
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	
	return next_state
	
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state

func took_damage() -> PlayerState: #If player has taken damage go to hurt state
	return hurt
