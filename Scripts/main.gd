extends Node2D

@export var spawn_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	spawn_position = $Player.global_position  # remembers wherever Player starts in the editor
	$Player.health_changed.connect($HUD/HealthBar.set_health_stage)
	$Player.player_died.connect(_on_player_died)

func _on_player_died() -> void:
	$Player.global_position = spawn_position
	$Player.velocity = Vector2.ZERO
	$Player.reset_health()
