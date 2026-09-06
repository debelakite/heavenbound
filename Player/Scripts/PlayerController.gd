class_name Player extends CharacterBody2D

#region ///hit_boxes
@onready var hit_boxL: HitBox = %HitBoxL
@onready var hit_boxR: HitBox = %HitBoxR
@onready var hit_boxU: HitBox = %HitBoxU
@onready var hit_boxD: HitBox = %HitBoxD
#endregion

#region ///onready variables
@onready var zeal_meter: ResourceMeter = $ZealMeter
@onready var key_item_inventory: KeyItemInventory = $KeyItemInventory
@onready var boon_manager: BoonManager = $BoonManager
#endregion

#region /// export variables
@export var move_speed : float = 450
#endregion

#region /// State Machine Variables
var states : Array[ PlayerState ]
var current_state : PlayerState :
	get : return states.front()
var previous_state : PlayerState :
	get : return states[ 1 ]
var hurt_state : PlayerState
#endregion

#region /// player progression variables
var progress = 0
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var ignore_gravity: bool = false
var base_move_speed: int = 100
var looking_up = false
var looking_down = false
@export var dash_cooldown: float = 0.8
var dash_cooldown_timer: float = 0.0
var has_landed = true

@export var invincibility_duration: float = 1.0
var is_invincible: bool = false
#endregion

#region /// Health Variables
@export var max_health_stage: int = 4  # 0 = dead, 4 = full health (5 total stages)
var health_stage: int = 4
signal health_changed(new_stage: int)
signal player_died
var is_dead: bool = false
var respawn_position: Vector2
#endregion

#region /// Camera Look-Down Variables
@export var look_down_offset: float = 150.0
@export var look_speed: float = 5.0
@onready var camera: Camera2D = $Camera2D
#region /// Animation Variables
@onready var _animation_player = $AnimatedSprite2D
@onready var swing_particles: GPUParticles2D = %SwingParticlesR
@export var flash_interval: float = 0.1
#endregion

# Safe Position Tracking for spikes
var last_safe_position: Vector2 = Vector2.ZERO
#region /// Sound Variables
@export var footstep_interval := 0.4  # tune to walk speed
var footstep_timer := 0.0
#endregion


# 	HEALTHBAR

func take_damage(amount: int, source: Node = null, trigger_hurt_state: bool = true) -> void:
	if is_dead or is_invincible:
		return
	health_stage = clamp(health_stage - amount, 0, max_health_stage)
	GameState.health_stage = health_stage
	health_changed.emit(health_stage)
	if health_stage == 0:
		_die()
		return
	if trigger_hurt_state:
		change_state(current_state.took_damage())
	_start_invincibility()

func _die() -> void:
	is_dead = true
	player_died.emit()
	change_state(current_state.died())

func _start_invincibility() -> void:
	is_invincible = true
	_flash()
	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false
	_animation_player.visible = true

func _flash() -> void:
	while is_invincible:
		_animation_player.visible = not _animation_player.visible
		await get_tree().create_timer(flash_interval).timeout

# HEALING (yet to be implemented)
func heal(amount: int = 1) -> void:
	health_stage = clamp(health_stage + amount, 0, max_health_stage)
	GameState.health_stage = health_stage
	health_changed.emit(health_stage)

# RESET HEALTH ON DEATH
func reset_health() -> void:
	health_stage = max_health_stage
	is_dead = false
	GameState.health_stage = health_stage
	health_changed.emit(health_stage)


	#Intialise the player states upon game start
func _ready() -> void:
	_animation_player.frame_changed.connect(_on_frame_changed)
	#TEST BOON
	var test_boon = preload("res://Resources/Boons/divinity_siphon.tres")
	$BoonManager.discover_boon(test_boon)
	#pull from a loaded save, if one exists
	if GameState.health_stage != -1:
		respawn_position = GameState.respawn_position
		global_position = GameState.respawn_position
		health_stage = GameState.health_stage
		health_changed.emit(health_stage)
		if has_node("HurtBox"):
			get_node("HurtBox").monitorable = true
	else:
		respawn_position = global_position
	initialize_states()
	if Hud: 
		Hud.register_player(self)
	else:
		push_error("Player: HUD Autoload singleton could not be found!")
	

func _on_frame_changed():
	if _animation_player.animation == "Run": #Selects which animation will play sfx
		if _animation_player.frame == 2 or _animation_player.frame == 5: # plays sfx based on number of foot contact frames
			_on_footstep_frame()

func _on_footstep_frame():
	var surface = get_surface_under_feet()
	SoundManager.play_footstep(surface)









	# Look down option when pressing S key
func update_camera_look() -> void:
	var target_offset_y = 0.0
	if Input.is_action_pressed("move_down"):
		target_offset_y = look_down_offset

	camera.offset.y = lerp(camera.offset.y, target_offset_y, look_speed * get_process_delta_time())

	#On input call the handle input function of the current state
func _unhandled_input(event: InputEvent) -> void:
	if is_dead:
		return
	change_state( current_state.handle_input( event ) )
	pass

	#Update function, runs every tick
	#_delta: time from last frame
func _process( _delta: float) -> void:
	update_direction()
	update_camera_look()
	change_state( current_state.process( _delta ) )


	#Update function for physics, runs every tick
	#_delta: time from last frame
func _physics_process( _delta: float) -> void:
	if not is_on_floor() and not ignore_gravity:
		velocity.y += gravity * _delta
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= _delta
	change_state( current_state.physics_process( _delta ) )
	move_and_slide()
	


	if is_on_floor():
		last_safe_position = global_position


#Gathers all player states in an array and initializes them
func initialize_states() -> void:
	states = []
	#gather all the states
	for c in $States.get_children():
		if c is PlayerState:
			states.append( c )
			c.player = self
		pass
	
	if states.size() == 0:
		return
	
	#initialize all the states
	for state in states:
		state.init()
		state.setup(self)

	change_state( current_state )	
	current_state.enter()
	$Label.text = current_state.name
	pass
	
	#Handles the changing of states
	#new_state: the state the player character is to enter
func change_state( new_state : PlayerState ) -> void:
	if new_state == null: #If the new state does not exist do nothing
		return
	elif new_state == current_state: #If the new state is the same as the old one, do nothing
		return
	
	if current_state: #If we are in a state, exit it
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	states.resize( 3 )
	$Label.text = current_state.name
	pass
	
	#Switches looking direction
func update_direction() -> void:
	#var prev_direction : Vector2 = direction
	var x_axis = Input.get_axis("move_left", "move_right")
	var y_axis = Input.get_axis("look_up", "move_down")
	direction = Vector2(x_axis, y_axis) 
	
	#Look up or down
	looking_down = direction.y > 0
	looking_up = direction.y < 0
	#Flips player sprite in direction faced
	if direction.x < 0:
		_animation_player.flip_h = false
	elif direction.x > 0:
		_animation_player.flip_h = true
	pass




func get_surface_under_feet() -> String:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + Vector2(0, 70)
	)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		print("hit collider: ", result.collider.name, " meta: ", result.collider.get_meta("surface_type") if result.collider.has_meta("surface_type") else "NONE")
	else:
		print("ray hit nothing")
	if result and result.collider.has_meta("surface_type"):
		return result.collider.get_meta("surface_type")
	return "stone"
