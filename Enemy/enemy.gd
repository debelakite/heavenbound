extends Node2D

@export var hover_amplitude: float = 20.0
@export var hover_speed: float = 2.0
@export var damage_amount: int = 1
@export var damage_interval: float = 1.0  # seconds between damage ticks

var start_position: Vector2
var time_elapsed: float = 0.0
var player_inside: CharacterBody2D = null
var damage_timer: float = 0.0

@onready var hitbox_area: Area2D = $HitboxArea

func _ready() -> void:
	start_position = global_position
	hitbox_area.body_entered.connect(_on_hitbox_body_entered)
	hitbox_area.body_exited.connect(_on_hitbox_body_exited)

func _process(delta: float) -> void:
	time_elapsed += delta
	position.y = start_position.y + sin(time_elapsed * hover_speed) * hover_amplitude

	if player_inside:
		damage_timer += delta
		if damage_timer >= damage_interval:
			damage_timer = 0.0
			player_inside.take_damage(damage_amount)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = body
		damage_timer = damage_interval  # deal damage immediately on first contact
		# (set to 0.0 instead if you'd rather wait a full interval before the first tick)

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		damage_timer = 0.0
