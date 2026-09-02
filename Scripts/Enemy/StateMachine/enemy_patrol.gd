@icon("res://Player/States/state.png")
class_name EnemyStatePatrol extends EnemyState
@export var patrol_speed: float = 160.0
@onready var player: Node2D = null

@onready var _animation_player = $AnimatedSprite2D

@export var patrol_speed_multiplier: float = 0.3  # slower than chase speed, tweak as needed
@export var pause_at_turn: float = 0.0  # optional pause before turning, 0 = no pause

var turn_timer: float = 0.0
var is_paused: bool = false

func init() -> void:
	pass

func enter() -> void:
	enemy.animated_sprite.play("Patrol")  # adjust to your actual walk animation name
	turn_timer = 0.0
	is_paused = false

func exit() -> void:
	pass

func physics_process(_delta: float) -> EnemyState:
	if enemy.chase and enemy.has_node("States/Chase"):
		return enemy.get_node("States/Chase")
	
	if is_paused:
		turn_timer -= _delta
		enemy.velocity.x = 0
		if turn_timer <= 0.0:
			is_paused = false
		return null
	
	var dir = 1.0 if enemy.facing_right else -1.0
	enemy.velocity.x = dir * enemy.speed * patrol_speed_multiplier
	
	var hit_wall = enemy.is_wall_ahead()
	var at_ledge = enemy.is_on_floor() and not enemy.is_ground_ahead()
	
	if hit_wall or at_ledge:
		enemy.set_facing(not enemy.facing_right)
		if pause_at_turn > 0.0:
			is_paused = true
			turn_timer = pause_at_turn
	
	return null
