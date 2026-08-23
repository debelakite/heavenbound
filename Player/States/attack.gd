@icon( "res://Player/States/state.png" )
class_name PlayerStateAttack extends PlayerState

@export var HIT_DURATION = 0.6
@export var horizontal_pushback = 500
@export var vertical_pushback = 0

var hit_timer = 0
#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	#TODO play animation
	#Decide on which way the player is attacking, depending on direction they are looking in
	if player.looking_down:
		hit_boxD.set_active(true)
	elif player.looking_up:
		hit_boxU.set_active(true)
		
	elif !player._animation_player.flip_h:
		hit_boxL.set_active(true)
	else:
		hit_boxR.set_active(true)
		#Plays particle effect
		if player.swing_particles_right:
			player.swing_particles_right.restart()
			player.swing_particles_right.emitting = true

	



	hit_timer = 0

	#Run code upon state exit
func exit() -> void:
	#Make sure they are not attacking anything anymore
	hit_boxL.set_active(false)
	hit_boxR.set_active(false)
	hit_boxU.set_active(false)
	hit_boxD.set_active(false)
	
	#Function called upon keyboard input, 
	#_event: keyboard button pressed
func handle_input( _event : InputEvent) -> PlayerState:
	
	if _event.is_action_pressed("jump",true) && player.is_on_floor(): #On jump input - enter jump state
		return jump
	return next_state


	#Update function, runs every tick
	#_delta: time from last frame
func process( _delta: float ) -> PlayerState:
	
	hit_timer += _delta
	if hit_timer >= HIT_DURATION: #Do not allow infinite attack spam
		hit_timer = 0
		if player.velocity.x != 0: #Go to the correct state upon completion
			return run
		else:
			return idle 
	return next_state
	
	#Update function for physics, runs every tick
	#_delta: time from last frame
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed #Decelarate player
	#Knock player back depending on attacking direction
	if hit_boxL.hit: 
		hit_boxL.hit = false
		player.velocity.x = horizontal_pushback
	if hit_boxR.hit: 
		hit_boxR.hit = false
		player.velocity.x = -horizontal_pushback
	if hit_boxU.hit: 
		hit_boxU.hit = false
		player.velocity.y = vertical_pushback
	if hit_boxD.hit: 
		hit_boxD.hit = false
		player.velocity.y = -vertical_pushback
	
	return next_state
	
func took_damage() -> PlayerState: #If player has taken damage, go to hurt state
	return hurt
