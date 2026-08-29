@icon("res://Player/States/state.png")
class_name PlayerStateDead extends PlayerState

@onready var _animation_player = $AnimatedSprite2D

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
	player._animation_player.play("Death")

# Run code upon state exit
func exit() -> void:
	pass  # terminal state — this shouldn't normally be reached

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
	
# in PlayerStateDead
func died() -> PlayerState:
	return next_state
