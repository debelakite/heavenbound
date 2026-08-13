class_name PlayerState extends Node

var player: Player
var next_state: PlayerState

var hit_box: HitBox
#region /// state references
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var hurt: PlayerStateHurt = %Hurt
@onready var attack: PlayerStateAttack = %Attack


	
#endregion
func setup(p: Player) -> void:
	player = p
	hit_box = p.hit_box
	print(hit_box)
	#What happens when this state is initialized?
func init() -> void:
	pass
		
	#What happens when we enter this state?
func enter() -> void:
	pass
		
	#What happens when we exit this state?
func exit() -> void:
	pass
	
	#What happens when an input is pressed?
func handle_input( _event : InputEvent) -> PlayerState:
	
	return next_state


	#What happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	
	return next_state
	
	
	#What happens each physics_process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	return next_state
