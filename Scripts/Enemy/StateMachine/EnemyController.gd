class_name Enemy extends CharacterBody2D

@export var speed: float = 150.0
@export var damage_amount: int = 1
@export var damage_interval: float = 1.0  # seconds between damage ticks

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var hitbox_area: Area2D = %HitBox
@onready var player_detection_area: Area2D = $DetectionArea
@onready var player_lose_area: Area2D = $LoseArea                 # larger: only THIS stops chase
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var ledge_check: RayCast2D = $LedgeCheck
@onready var wall_check: RayCast2D = $WallCheck

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase: bool = false
var player_inside: CharacterBody2D = null
var damage_timer: float = 0.0

#region /// State Machine Variables
var states : Array[ EnemyState ]
var current_state : EnemyState :
	get : return states.front()
var previous_state : EnemyState :
	get : return states[ 1 ]
var hurt_state : EnemyState
#endregion



func _ready() -> void:
	initialize_states()
	print("Player found: ", player)
	print("Players in group: ", get_tree().get_nodes_in_group("player"))
	hitbox_area.body_entered.connect(_on_hitbox_body_entered)
	hitbox_area.body_exited.connect(_on_hitbox_body_exited)
	player_detection_area.body_entered.connect(_on_player_detection_body_entered)
	player_lose_area.body_exited.connect(_on_player_lose_body_exited)

	if player == null:
		push_warning("Enemy: no node found in group 'player'. Chase logic will not work.")

#Update function, runs every tick
	#_delta: time from last frame
func _process( _delta: float) -> void:
	if not is_instance_valid(player):
		return
	change_state( current_state.process( _delta ) )

func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * _delta
	change_state(current_state.physics_process(_delta))
	move_and_slide()


	if chase and is_instance_valid(player):
		var x_diff: float = player.global_position.x - global_position.x
		var direction_x: float = sign(x_diff)  # -1.0, 0.0, or 1.0 — pure left/right, no vertical dilution
		animated_sprite.flip_h = direction_x > 0
		velocity.x = direction_x * speed
	else:
		velocity.x = 0

	move_and_slide()

#Gathers all enemy states in an array and initializes them
func initialize_states() -> void:
	states = []
	#gather all the states
	for c in $States.get_children():
		if c is EnemyState:
			states.append( c )
		pass
		
	if states.size() == 0:
		return
	
	#initialize all the states
	for state in states:
		state.init()
		state.setup(self)
		
	change_state( current_state )	
	current_state.enter()
	$StateLabel.text = current_state.name
	pass



func is_ground_ahead() -> bool:
	return ledge_check.is_colliding()

func is_wall_ahead() -> bool:
	return wall_check.is_colliding()
	
	#Handles the changing of states
	#new_state: the state the player character is to enter
func change_state( new_state : EnemyState ) -> void:
	if new_state == null: #If the new state does not exist do nothing
		return
	elif new_state == current_state: #If the new state is the same as the old one, do nothing
		return
	if current_state: #If we are in a state, exit it
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	states.resize( 3 )
	$StateLabel.text = current_state.name
	pass

func update_direction(facing_right: bool) -> void:
	# Flip raycasts to match facing direction
	ledge_check.position.x = abs(ledge_check.position.x) * (1 if facing_right else -1)
	wall_check.position.x = abs(wall_check.position.x) * (1 if facing_right else -1)
	#TODO also flip sprite here
	
func _on_player_detection_body_entered(body: Node2D) -> void:
	print("Something entered detection area: ", body.name)
	if body.is_in_group("player"):
		chase = true
		print("CHASE TRUE  t=", Time.get_ticks_msec())


func _on_player_lose_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		chase = false
		print("CHASE FALSE t=", Time.get_ticks_msec())


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = body
		damage_timer = damage_interval  # deal damage immediately on first contact


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		damage_timer = 0.0
