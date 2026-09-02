@icon( "res://Player/States/state.png" )
class_name PlayerStateJump extends PlayerState

@onready var _animation_player = $AnimatedSprite2D
@export var jump_velocity : float = 450.0 #Constant for start jump velocity
@export var min_jump_velocity = -150.0 # Velocity when button is tapped shortly

	#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	player._animation_player.play("Jump")
	player.velocity.y = -jump.jump_velocity #Cordinate graph has negative y values upwards, to accelarate up flip speed to negative 
	
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( event : InputEvent) -> PlayerState:

	if event.is_action_pressed("attack",true):
		return attack
	if event.is_action_pressed("dash", true) and player.dash_cooldown_timer <= 0.0:
		return dash
	if event.is_action_pressed("special"):
		return shoot
	if event.is_action_pressed("jump"): 
		#On pressing jump again go to floating
		return floating
		
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
	
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		if player.velocity.y < min_jump_velocity: 
			player.velocity.y = min_jump_velocity
	
	if player.velocity.y >= 0: #If player upwards velocity is over 0 (i.e. falling) go to fall state
		return fall
	return next_state

func took_damage() -> PlayerState: #If player has taken damage go to hurt state
	return hurt
