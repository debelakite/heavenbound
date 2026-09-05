@icon( "res://Player/States/state.png" )
class_name PlayerStateRun extends PlayerState

@onready var _animation_player = $AnimatedSprite2D
@export var coyote_time = 0.1
var coyote_timer = 0

	#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	player._animation_player.play("Run")
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

	if _event.is_action_pressed("special", true) and player.zeal_meter.try_cast("shotgun_shot"):
		return shoot

	if _event.is_action_pressed("heal", true): #On heal input - enter heal state
		return heal

	return next_state
	


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	if player.direction.x == 0 && player.is_on_floor(): #If player on floor and not moving, enter idle state
		return idle
	return next_state
	
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
	
func physics_process( delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false: #If player not on floor but running, enter fall state
		#Delay falling for a bit after no longer being on the ground
		coyote_timer += delta
		if coyote_timer > coyote_time:
			return fall
	return next_state

func took_damage() -> PlayerState: #If player has taken damage, go to hurt state
	return hurt
