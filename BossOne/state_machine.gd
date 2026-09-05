# StateMachine.gd
extends Node
class_name StateMachine

@export var initial_state: BossState
var current_state: BossState
var boss: BossController

func _ready():
	boss = owner as BossController
	for child in get_children():
		child.boss = boss
	current_state = initial_state


func start():
	current_state.enter()

func _physics_process(delta):
	current_state.physics_update(delta)

func transition_to(state_name: String):
	current_state.exit()
	current_state = get_node(state_name)
	current_state.enter()
