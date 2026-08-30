@icon( "res://Player/States/state.png" )
class_name PlayerStateAttack extends PlayerState

@onready var _animation_player = $AnimatedSprite2D
@export var HIT_DURATION = 0.4 #animation plays twice if duration is >0.4
@export var horizontal_pushback = 500
@export var vertical_pushback = 0
@export var vfx_offset_down = Vector2(0, 80)
@export var vfx_offset_up = Vector2(0, -80)
@export var vfx_offset_left = Vector2(-80, 0)
@export var vfx_offset_right = Vector2(80, 0)

var hit_timer = 0

#Initialisation of the state
func init() -> void:
	pass
		
	#Run code upon state entrance
func enter() -> void:
	
	
	print("ATTACK enter() called")

	if player.looking_down:
		player._animation_player.play("AttackDown")
		var vfx = preload("res://Scenes/VFXPlayer.tscn").instantiate()
		hit_boxD.add_child(vfx)
		vfx.position = vfx_offset_down
		vfx.play_vfx("Slash", false, true, -90)
		print("Activating hit_boxD")
		hit_boxD.set_active(true)
		if player.swing_particles:
			player.swing_particles.restart()
			player.swing_particles.emitting = true
	elif player.looking_up:
		player._animation_player.play("AttackUp")
		var vfx = preload("res://Scenes/VFXPlayer.tscn").instantiate()
		hit_boxU.add_child(vfx)
		vfx.position = vfx_offset_up
		vfx.play_vfx("Slash", true, false, -90)
		print("Activating hit_boxU")
		hit_boxU.set_active(true)
		if player.swing_particles:
			player.swing_particles.restart()
			player.swing_particles.emitting = true
	elif !player._animation_player.flip_h:
		player._animation_player.play("Attack")
		var vfx = preload("res://Scenes/VFXPlayer.tscn").instantiate()
		hit_boxL.add_child(vfx)
		vfx.position = vfx_offset_left
		vfx.play_vfx("Slash", false, false)
		print("Activating hit_boxL")
		hit_boxL.set_active(true)
		if player.swing_particles:
			player.swing_particles.restart()
			player.swing_particles.emitting = true
	else:
		player._animation_player.play("Attack")
		var vfx = preload("res://Scenes/VFXPlayer.tscn").instantiate()
		hit_boxR.add_child(vfx)
		vfx.position = vfx_offset_right
		vfx.play_vfx("Slash", true, false)
		print("Activating hit_boxR")
		hit_boxR.set_active(true)
		if player.swing_particles:
			player.swing_particles.restart()
			player.swing_particles.emitting = true

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
	if _event.is_action_pressed("dash", true) and player.dash_cooldown_timer <= 0.0:
		return dash
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
