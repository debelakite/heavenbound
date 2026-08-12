extends Node2D

@export var spawn_position: Vector2 = Vector2.ZERO
@export var respawn_delay: float = 1.5  # seconds before respawning

func _ready() -> void:
	spawn_position = $Player.global_position
	$Player.health_changed.connect($HUD/HealthBar.set_health_stage)
	$Player.player_died.connect(_on_player_died)


# uppon death
func _on_player_died() -> void:
	# show deathscreen
	$HUD/DeathScreen.visible = true
	
	await get_tree().create_timer(respawn_delay).timeout
	
	# put player back at spawn
	$Player.global_position = spawn_position
	# with zero velocity
	$Player.velocity = Vector2.ZERO
	# and reset health
	$Player.reset_health()
	$HUD/DeathScreen.visible = false
