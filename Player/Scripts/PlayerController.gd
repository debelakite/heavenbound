class_name Player extends CharacterBody2D

@onready var hit_box: HitBox = %HitBox

#region /// export variables
@export var move_speed : float = 350
#endregion

#region /// State Machine Variables
var states : Array[ PlayerState ]
var current_state : PlayerState :
	get : return states.front()
var previous_state : PlayerState :
	get : return states[ 1 ]
var hurt_state : PlayerState
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var base_move_speed: int = 100
#endregion

#region /// Health Variables
@export var max_health_stage: int = 4  # 0 = dead, 4 = full health (5 total stages)
var health_stage: int = 4
signal health_changed(new_stage: int)
signal player_died
#endregion

#region /// Camera Look-Down Variables
@export var look_down_offset: float = 150.0
@export var look_speed: float = 5.0
@onready var camera: Camera2D = $Camera2D
#region /// Animation Variables
@onready var _animation_player = $AnimatedSprite2D
#endregion



# 	HEALTHBAR

func take_damage(amount: int = 1) -> void:
	health_stage = clamp(health_stage - amount, 0, max_health_stage)
	health_changed.emit(health_stage)
	change_state(current_state.took_damage())
	if health_stage == 0:
		player_died.emit()

# HEALING (yet to be implemented)
func heal(amount: int = 1) -> void:
	health_stage = clamp(health_stage + amount, 0, max_health_stage)
	health_changed.emit(health_stage)

# RESET HEALTH ON DEATH
func reset_health() -> void:
	health_stage = max_health_stage
	health_changed.emit(health_stage)


	#Intialise the player states upon game start
func _ready() -> void:
	initialize_states()
	pass
	
	# Look down option when pressing S key
func update_camera_look() -> void:
	var target_offset_y = 0.0
	if Input.is_action_pressed("move_down"):
		target_offset_y = look_down_offset

	camera.offset.y = lerp(camera.offset.y, target_offset_y, look_speed * get_process_delta_time())

	#On input call the handle input function of the current state
func _unhandled_input(event: InputEvent) -> void:
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
	#print("Class: ", current_state.get_script().resource_path)
	velocity.y += gravity * _delta
	change_state( current_state.physics_process( _delta ) )
	move_and_slide()


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
	var y_axis = Input.get_axis("jump", "move_down")
	direction = Vector2(x_axis, y_axis) 
	
	#Flips player sprite in direction faced
	if direction.x < 0:
		_animation_player.flip_h = false
	elif direction.x > 0:
		_animation_player.flip_h = true
	pass
	
