@icon( "res://Player/States/state.png" )
class_name PlayerStateIdle extends PlayerState

@onready var _animation_player = $AnimatedSprite2D
@export var coyote_time = 0.1
var coyote_timer = 0

	#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	player._animation_player.play("Idle")
	coyote_timer = 0
		
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("attack",true):
		return attack

	if _event.is_action_pressed("dash", true) and player.dash_cooldown_timer <= 0.0:

		return dash
	elif _event.is_action_pressed("jump",true): #On jump input - enter jump state
		return jump
	if _event.is_action_pressed("heal", true): #On heal input - enter heal state
		return heal
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	if player.direction.x != 0 && player.is_on_floor(): #If player is on floor and moving horizantelly, enter run state
		return run
	return next_state
	
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( delta: float ) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false: #If player is not on floor and is in an idle state, enter fall state
		#Delay falling for a bit after no longer being on the ground
		coyote_timer += delta
		if coyote_timer > coyote_time:
			return fall
	return next_state

func took_damage() -> PlayerState: #If player has taken damage go to hurt state
	return hurt
