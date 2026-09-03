@icon( "res://Player/States/state.png" )
class_name PlayerStateFloat extends PlayerState

@export var float_limit = 3
var float_time = 0

#Initialisation of the state
func init() -> void:
	#Add player progress to the max time the character can float
	float_limit += player.progress
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	#If player enters fall state the first time after leaving ground, give a small boost up
	if player.has_landed:
		float_time = 0
		player.has_landed = false
		player.velocity.y = -340

	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("attack",true):
		#If attack is pressed, comence an attack
		return attack
	if _event.is_action_pressed("dash") and player.dash_cooldown_timer <= 0.0:
		#Allow for dashing while floating
		return dash
	if _event.is_action_released("jump"): 
		#On releasing jump return to falling
		return fall
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( delta: float ) -> PlayerState:
	float_time += delta
	#If player has floated for too long, stop floating
	if float_time > float_limit:
		return fall
	return next_state
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed #Decelarate player
	#if player has not floated too much, start floating
	if player.velocity.y > 100 && float_time < float_limit :
		player.velocity.y = 100
	#If player has landed, mark it and return to idle
	if player.is_on_floor():
		player.has_landed = true
		return idle
	return next_state
	
func took_damage() -> PlayerState: #If player has taken damage, go to hurt state
	return hurt
