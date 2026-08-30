# VFXPlayer.gd
extends Node2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.animation_finished.connect(queue_free)

func play_vfx(anim_name: String, flip_h: bool = false, flip_v: bool = false, rotation_degrees: float = 0.0):
	sprite.animation = anim_name
	sprite.flip_h = flip_h
	sprite.flip_v = flip_v
	self.rotation_degrees = rotation_degrees
	sprite.play()
