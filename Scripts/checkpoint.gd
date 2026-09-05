extends Area2D
class_name Checkpoint

@export var spawn_point: Marker2D
@onready var _animation_player = $AnimatedSprite2D
var activated: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox"):
		var player = area.owner_player
		if player:
			_activate()
			if player.has_node("BoonManager"):
				player.get_node("BoonManager").enter_loadout_mode()

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox"):
		var player = area.owner_player
		if player and player.has_node("BoonManager"):
			player.get_node("BoonManager").exit_loadout_mode()
			_deactivate()

func _activate() -> void:
	if activated:
		return
	activated = true
	var pos = spawn_point.global_position if spawn_point else global_position
	GameState.set_checkpoint(pos, get_tree().current_scene.scene_file_path)
	print("checkpoint set: ", pos, " in scene: ", get_tree().current_scene.scene_file_path)

	_animation_player.play("Activate")
	await _animation_player.animation_finished
	_animation_player.play("Active")

func _deactivate() -> void:
	if not activated:
		return
	activated = false

	_animation_player.play("Deactivate")
	await _animation_player.animation_finished
	_animation_player.play("Inactive")
	_animation_player.stop()  # freezes on first frame since Inactive is "static"
