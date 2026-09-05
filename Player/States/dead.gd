@icon("res://Player/States/state.png")
class_name PlayerStateDead extends PlayerState

@onready var _animation_player = $AnimatedSprite2D
@export var respawn_delay: float = 2.0

# Initialisation of the state
func init() -> void:
	pass

# Run code upon state entrance
func enter() -> void:
	player._animation_player.play("Dead")
	player.velocity = Vector2.ZERO
	player.set_physics_process(true)  # keep gravity applying if you want the body to settle/fall, or set false to freeze entirely
	if player.has_node("HurtBox"):
		player.get_node("HurtBox").monitorable = false  # can't be hit again while dead
	_respawn_after_delay()

# Run code upon state exit
func exit() -> void:
	pass

func _respawn_after_delay() -> void:
	await get_tree().create_timer(respawn_delay).timeout
	_respawn()

func _respawn() -> void:
	if GameState.respawn_scene_path != "" and GameState.respawn_scene_path != get_tree().current_scene.scene_file_path:
		get_tree().call_deferred("change_scene_to_file", GameState.respawn_scene_path)
	player.reset_health()
	player.velocity = Vector2.ZERO  # clear any leftover fall/knockback velocity
	var health = player.health_stage
	player.global_position = GameState.respawn_position
	if player.has_node("HurtBox"):
		player.get_node("HurtBox").monitorable = true
	player.change_state(idle)

# Function called upon keyboard input
func handle_input(_event: InputEvent) -> PlayerState:
	return next_state  # ignore all input while dead

# Update function, runs every tick
func process(_delta: float) -> PlayerState:
	return next_state  # no transitions out of death via normal update logic

# Update function for physics, runs every tick
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	return next_state  # stay dead — don't fall into 'fall', don't respond to floor state

func took_damage() -> PlayerState:
	return next_state  # already dead, ignore further damage

func died() -> PlayerState:
	return next_state
