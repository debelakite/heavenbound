# BossController.gd
extends CharacterBody2D
class_name BossController

@onready var _animation_player = %AnimatedSprite2D
@onready var hitbox_area: Area2D = $HitBoxArea
@onready var hurtbox_area: Area2D = $HurtBoxArea
@onready var state_machine: StateMachine = $StateMachine

@export var attack_pools: Array[Array] = []       # Array[Array[AttackData]], indexed by phase
@export var phase_thresholds: Array[float] = [0.5, 0.2]
@export var max_phase: int = 3
@export var max_hp: float = 500.0
@export var max_poise: float = 100.0

var current_hp: float
var poise: float
var phase: int = 1
var current_attack: AttackData
var last_attack_name: String = ""
var cooldowns: Dictionary = {}

func _ready():
	current_hp = max_hp
	poise = max_poise
	hurtbox_area.area_entered.connect(_on_hurtbox_area_entered)
	state_machine.start() 

func _physics_process(delta):
	# cooldowns tick centrally, independent of state
	for key in cooldowns.keys():
		cooldowns[key] = max(0.0, cooldowns[key] - delta)

func hp_percent() -> float:
	return current_hp / max_hp

func dist_to_player() -> float:
	var player = get_tree().get_first_node_in_group("player")
	return global_position.distance_to(player.global_position) if player else INF

func _on_hurtbox_area_entered(area: Area2D):
	if area.is_in_group("player_hitbox"):
		var dmg = area.get_damage()
		var poise_dmg = area.get_poise_damage()
		state_machine.current_state.handle_hit(dmg, poise_dmg)
