extends CanvasLayer
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func change_scene(target_path: String, spawn_point_id: String = "") -> void:
	anim_player.speed_scale = 3.0
	anim_player.play_backwards("fade_in")
	await anim_player.animation_finished
	anim_player.speed_scale = 1.0

	get_tree().change_scene_to_file(target_path)

	# Wait one frame so the new scene actually finishes loading in
	await get_tree().process_frame

	if not spawn_point_id.is_empty():
		var player: Node2D = get_tree().get_first_node_in_group("player")
		var spawn_marker: Node2D = get_tree().current_scene.find_child(spawn_point_id, true, false)
		if player and spawn_marker:
			player.global_position = spawn_marker.global_position
		elif not spawn_marker:
			print("WARNING: No spawn point found matching id: ", spawn_point_id)

	anim_player.play("fade_in")
