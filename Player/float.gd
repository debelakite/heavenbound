@icon( "res://Player/States/state.png" )
class_name PlayerStateFloat extends PlayerState

@export var bad_controls = true
@export var timed_float = false
@export var float_limit = 3
var float_time = 0
var time_since_change = 0
var random_move = (randf_range(-2,2))

#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
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
	if timed_float && float_time > float_limit:
		return fall
	return next_state
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed #Decelarate player
	time_since_change += delta
	if bad_controls:
		if time_since_change > 0.5:
			time_since_change = 0
			random_move = (randf_range(-1,1))
		player.velocity.x += 150 * random_move
	if player.velocity.y > 100 && (float_time < float_limit || !timed_float)  :
		player.velocity.y = 100
	if player.is_on_floor():
		player.has_landed = true
		return idle
	return next_state
	
func took_damage() -> PlayerState: #If player has taken damage, go to hurt state
	return hurt
