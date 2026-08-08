extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0
const CROUCH_SPEED_MULTIPLIER = 0.5

var is_crouching = false

func physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_key_pressed(KEY_W) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Crouch
	is_crouching = Input.is_key_pressed(KEY_S) and is_on_floor()

	# Horizontal movement
	var direction = 0.0
	if Input.is_key_pressed(KEY_A):
		direction -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction += 1.0

	var current_speed = SPEED
	if is_crouching:
		current_speed *= CROUCH_SPEED_MULTIPLIER

	velocity.x = direction * current_speed

	move_and_slide()
