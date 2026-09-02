@icon( "res://Player/States/state.png" )
class_name PlayerStateShooting extends PlayerState


@export var HIT_DURATION = 0.4 #animation plays twice if duration is >0.4
@export var horizontal_pushback = 500
@export var vertical_pushback = 0
const shot := preload("res://Player/Attacks/Shot.tscn")

var shot_timer = 0

#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	shot_timer = 0
	var projectile_instance = shot.instantiate() as Shot
	projectile_instance.position = player.position
	if player.looking_down:
		projectile_instance.direction = Vector2.DOWN
	elif player.looking_up:
		projectile_instance.direction = Vector2.UP
	elif !player._animation_player.flip_h:
		projectile_instance.direction = Vector2.LEFT
	else:
		projectile_instance.direction = Vector2.RIGHT
	player.add_child(projectile_instance)
	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	
	if _event.is_action_pressed("jump",true) && player.is_on_floor(): #On jump input - enter jump state
		return jump
	if _event.is_action_pressed("dash", true) and player.dash_cooldown_timer <= 0.0:
		return dash
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( delta: float ) -> PlayerState:
	shot_timer += delta
	if shot_timer > 0.5:
		return idle
	return next_state
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed #Decelarate player
	
	return next_state
	
func took_damage() -> PlayerState: #If player has taken damage, go to hurt state
	return hurt
