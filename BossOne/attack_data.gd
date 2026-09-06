extends Resource
class_name AttackData

@export var name: String
@export var min_phase: int = 1
@export var max_range: float = 300.0
@export var windup_time: float = 0.6
@export var active_time: float = 0.2
@export var recover_time: float = 0.8
@export var cooldown: float = 4.0
@export var telegraph_anim: String
@export var attack_anim: String
@export var tags: Array[String] = []
