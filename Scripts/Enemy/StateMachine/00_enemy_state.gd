class_name EnemyState extends Node

var enemy: Enemy
var next_state: EnemyState


var hit_box: HitBox

#region /// state references
@onready var idle: EnemyStateIdle = %Idle
@onready var chase: EnemyStateChase = %Chase


#endregion


func setup(e: Enemy) -> void:
	enemy = e

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
func handle_input( _event : InputEvent) -> EnemyState:
	
	return next_state


	#What happens each process tick in this state?
func process( _delta: float ) -> EnemyState:

	return next_state
	
	
	#What happens each physics_process tick in this state?
func physics_process( _delta: float ) -> EnemyState:
	
	return next_state
