@icon( "res://Player/States/state.png" )
class_name PlayerStateAttack extends PlayerState
@export var HIT_DURATION = 0.4
@export var horizontal_pushback = 20
var hit_timer = 0
#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	
	#Plays particle effect
	if player.swing_particles:
		player.swing_particles.restart()
		player.swing_particles.emitting = true

	hit_box.set_active(true)
	hit_timer = 0

	#Run code upon state exit
func exit() -> void:
	pass
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump",true): #On jump input - enter jump state
		return jump
	if _event.is_action_pressed("dash", true) and player.dash_cooldown_timer <= 0.0:
		return dash
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	
	hit_timer += _delta
	if hit_timer >= HIT_DURATION: #Do not allow infinite attack spam
		hit_timer = 0
		hit_box.set_active(false)
		if player.velocity.x != 0: #Go to the correct state upon completion
			return run
		else:
			return idle 
	return next_state
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed #Decelarate player
	if hit_box.hit: 
		hit_box.hit = false
		if player.velocity.x != 0: #Propel player oposite direction, or if player is not moving, just go left
			player.velocity.x = -(player.velocity.x/abs(player.velocity.x))*horizontal_pushback
		else:
			player.velocity.x = -horizontal_pushback
	return next_state
	
func took_damage() -> PlayerState: #If player has taken damage, go to hurt state
	return hurt
