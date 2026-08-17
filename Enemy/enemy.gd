extends CharacterBody2D

@export var speed: float = 150.0
@export var damage_amount: int = 1
@export var damage_interval: float = 1.0  # seconds between damage ticks

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var hitbox_area: Area2D = $HitboxArea
@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var player_lose_area: Area2D = $PlayerLoseArea                 # larger: only THIS stops chase
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase: bool = false
var player_inside: CharacterBody2D = null
var damage_timer: float = 0.0


func _ready() -> void:
	hitbox_area.body_entered.connect(_on_hitbox_body_entered)
	hitbox_area.body_exited.connect(_on_hitbox_body_exited)
	player_detection_area.body_entered.connect(_on_player_detection_body_entered)
	player_lose_area.body_exited.connect(_on_player_lose_body_exited)

	if player == null:
		push_warning("Enemy: no node found in group 'player'. Chase logic will not work.")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


	if chase and is_instance_valid(player):
		var x_diff: float = player.global_position.x - global_position.x
		var direction_x: float = sign(x_diff)  # -1.0, 0.0, or 1.0 — pure left/right, no vertical dilution
		animated_sprite.flip_h = direction_x > 0
		velocity.x = direction_x * speed
	else:
		velocity.x = 0

	move_and_slide()

	# Damage ticking moved here so we only need one processing callback.
	if player_inside:
		damage_timer += delta
		if damage_timer >= damage_interval:
			damage_timer = 0.0
			player_inside.take_damage(damage_amount)


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		chase = true


func _on_player_lose_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		chase = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = body
		damage_timer = damage_interval  # deal damage immediately on first contact


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		damage_timer = 0.0
