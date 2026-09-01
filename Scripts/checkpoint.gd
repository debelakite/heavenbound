extends Area2D
class_name Checkpoint

@export var spawn_point: Marker2D
@onready var _animation_player = $AnimatedSprite2D
var activated: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox"):
		var player = area.owner_player
		if player:
			_activate()

func _activate() -> void:
	if activated:
		return
	activated = true
	var pos = spawn_point.global_position if spawn_point else global_position
	GameState.set_checkpoint(pos, get_tree().current_scene.scene_file_path)
	print("checkpoint set: ", pos, " in scene: ", get_tree().current_scene.scene_file_path)
	#TODO play animation
	_animation_player.play("Activate")
