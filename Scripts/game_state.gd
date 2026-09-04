extends Node

var target_spawn_id: String = ""
var respawn_position: Vector2 = Vector2.ZERO
var respawn_scene_path: String = ""
var health_stage: int = -1  # -1 = no save data yet, use default

const SAVE_PATH := "user://savegame.save"

func _ready() -> void:
	load_game()
func set_checkpoint(pos: Vector2, scene_path: String) -> void:
	respawn_position = pos
	respawn_scene_path = scene_path
	save_game()

func save_game() -> void:
	var save_dict := {
		"respawn_position": {"x": respawn_position.x, "y": respawn_position.y},
		"respawn_scene_path": respawn_scene_path,
		"health_stage": health_stage,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_dict))
		file.close()
		print("game saved")
	else:
		push_error("GameState: failed to open save file for writing")

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("GameState: failed to open save file for reading")
		return false
	var text := file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if parsed == null:
		push_error("GameState: save file corrupted or unreadable")
		return false
	respawn_position = Vector2(parsed.respawn_position.x, parsed.respawn_position.y)
	respawn_scene_path = parsed.respawn_scene_path
	health_stage = parsed.health_stage
	print("game loaded")
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
	
func reset_to_defaults() -> void:
	respawn_position = Vector2.ZERO
	respawn_scene_path = ""
	health_stage = -1
