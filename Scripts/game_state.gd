extends Node

var respawn_position: Vector2 = Vector2.ZERO
var respawn_scene_path: String = ""

func set_checkpoint(pos: Vector2, scene_path: String) -> void:
	respawn_position = pos
	respawn_scene_path = scene_path
