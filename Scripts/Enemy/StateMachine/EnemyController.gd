class_name Enemy extends CharacterBody2D
@export var speed: float = 150.0
@export var damage_amount: int = 1
@export var damage_interval: float = 1.0
@export var flip_deadzone: float = 2.0
@export var flip_cooldown: float = 0.0
@export var stop_distance: float = 32.0
@export var max_health: int = 3
@export var invincibility_time: float = 0.3
var facing_right: bool = true
var flip_cooldown_timer: float = 0.0
var player: CharacterBody2D = null
var current_health: int
var invincibility_timer: float = 0.0
var is_dead: bool = false
var pending_knockback_dir: float = 0.0
@onready var hitbox_area: Area2D = %HitBox
@onready var player_detection_area: Area2D = $DetectionArea
@onready var player_lose_area: Area2D = $LoseArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ledge_check: RayCast2D = $LedgeCheck
@onready var wall_check: RayCast2D = $WallCheck
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase: bool = false
var player_inside: CharacterBody2D = null
var damage_timer: float = 0.0
var current_state: EnemyState = null
var previous_state: EnemyState = null
@onready var x_diff

signal health_changed(current: int, max: int)
signal died

func _ready() -> void:
	current_health = max_health
	acquire_player()
	initialize_states()
	
	if hitbox_area:
		hitbox_area.body_entered.connect(_on_hitbox_body_entered)
		hitbox_area.body_exited.connect(_on_hitbox_body_exited)
	if player_detection_area:
		player_detection_area.body_entered.connect(_on_player_detection_body_entered)
	if player_lose_area:
		player_lose_area.body_exited.connect(_on_player_lose_body_exited)
func acquire_player() -> void:
	if not is_instance_valid(player):
		var found_player = get_tree().get_first_node_in_group("player")
		if found_player is CharacterBody2D:
			player = found_player
func _physics_process(_delta: float) -> void:
	#print("Class: ", current_state.get_script().resource_path)
	acquire_player()
	if Player != null:
		x_diff = player.global_position.x - global_position.x
		print("Enemy Pos: ", global_position, " | Target Pos: ", player.global_position, " | x_diff: ", x_diff)
	if flip_cooldown_timer > 0.0:
		flip_cooldown_timer -= _delta
	if invincibility_timer > 0.0:
		invincibility_timer -= _delta
		
	if not is_on_floor():
		velocity.y += gravity * _delta
		
	if current_state:
		var next_state = current_state.physics_process(_delta)
		if next_state:
			change_state(next_state)
			
	move_and_slide()

func take_damage(amount: int, source: Node2D = null) -> void:
	if is_dead or invincibility_timer > 0.0:
		return
	
	current_health -= amount
	current_health = maxi(current_health, 0)
	invincibility_timer = invincibility_time
	health_changed.emit(current_health, max_health)
	
	if source:
		pending_knockback_dir = signf(global_position.x - source.global_position.x)
		if pending_knockback_dir == 0.0:
			pending_knockback_dir = -1.0 if facing_right else 1.0
	else:
		pending_knockback_dir = -1.0 if facing_right else 1.0
	
	if current_health <= 0:
		is_dead = true
		died.emit()
		change_state($States/Death)
	else:
		change_state($States/Hurt)

func evaluate_facing(x_diff: float) -> void:
	if flip_cooldown_timer > 0.0:
		return
	if facing_right and x_diff < -flip_deadzone:
		set_facing(false)
	elif not facing_right and x_diff > flip_deadzone:
		set_facing(true)
func set_facing(new_facing_right: bool) -> void:
	if new_facing_right == facing_right:
		return
	facing_right = new_facing_right
	flip_cooldown_timer = flip_cooldown
	animated_sprite.flip_h =  facing_right
	update_direction(facing_right)
func initialize_states() -> void:
	var children = $States.get_children()
	if children.size() == 0:
		return
		
	for c in children:
		if c is EnemyState:
			c.init()
			c.setup(self)
			
	current_state = $States.get_child(0) as EnemyState
	if current_state:
		current_state.enter()
		if has_node("StateLabel"):
			$StateLabel.text = current_state.name
func is_ground_ahead() -> bool:
	return ledge_check.is_colliding()
func is_wall_ahead() -> bool:
	return wall_check.is_colliding()
func change_state(new_state: EnemyState) -> void:
	if new_state == null or new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	previous_state = current_state
	current_state = new_state
	current_state.enter()
	if has_node("StateLabel"):
		$StateLabel.text = current_state.name
func update_direction(facing_right_: bool) -> void:
	var dir = 1.0 if facing_right_ else -1.0
	ledge_check.position.x = abs(ledge_check.position.x) * dir
	wall_check.position.x = abs(wall_check.position.x) * dir
func _on_player_detection_body_entered(body: Node2D) -> void:
	print("player has entered DetectionArea")
	if body.is_in_group("player"):
		chase = true
func _on_player_lose_body_exited(body: Node2D) -> void:
	print("player has exited LoseArea")
	if body.is_in_group("player"):
		chase = false
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = body as CharacterBody2D
		damage_timer = damage_interval
func _on_hitbox_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		damage_timer = 0.0
