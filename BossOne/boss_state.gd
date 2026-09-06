# BossState.gd (base class, same shape you're likely already using)
extends Node
class_name BossState

var boss: BossController

func enter(): pass
func exit(): pass
func physics_update(delta: float): pass
func handle_hit(damage: float, poise_damage: float): pass
