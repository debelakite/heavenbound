@icon( "res://Player/States/state.png" )
class_name PlayerStateHeal extends PlayerState

@onready var _animation_player = $AnimatedSprite2D
@export var HEAL_DURATION = 0.8  # how long the heal animation/vulnerability lasts
@export var heal_stages: int = 1 #how many health stages heal restores
var heal_timer = 0
var _already_healed = false

# Initialisation of the state
func init() -> void:
	pass

# Run code upon state entrance
func enter() -> void:
	heal_timer = 0
	_already_healed = false

	var meter: ResourceMeter = player.get_node("ZealMeter")
	if meter.try_heal():
		var speed_mult = player.boon_manager.get_heal_speed_multiplier()
		player._animation_player.play("Heal")
		player._animation_player.speed_scale = speed_mult
	else: #bails out of heal immediately if not enough zeal
		_already_healed = true  # prevents heal() from firing in process()
		next_state = idle
		return

# Run code upon state exit
func exit() -> void:
	pass

# Function called upon keyboard input
func handle_input(_event: InputEvent) -> PlayerState:
	# No dodging/attacking out of a heal
	# Remove this check entirely if you want heals to be interruptible.
	return next_state

# Update function, runs every tick
func process(_delta: float) -> PlayerState:
	heal_timer += _delta

	# Applies the actual health restore partway through the animation
	if not _already_healed and heal_timer >= HEAL_DURATION * 0.5:
		_already_healed = true
		player.heal(heal_stages)  # replace with your actual health system call

	if heal_timer >= HEAL_DURATION:
		heal_timer = 0
		if player.velocity.x != 0:
			return run
		else:
			return idle

	return next_state

# Update function for physics, runs every tick
func physics_process(_delta: float) -> PlayerState:
	# Player can't move while healing
	player.velocity.x = 0
	return next_state

func took_damage() -> PlayerState:
	# Getting hit while healing interrupts it — go to hurt state.
	return hurt
