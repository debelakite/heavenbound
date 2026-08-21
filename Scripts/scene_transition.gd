extends CanvasLayer

@onready var anim_player: AnimationPlayer = $AnimationPlayer


	
func change_scene(target_path: String) -> void:
	# 1. Play fade out and wait for signal from anim_player
	anim_player.speed_scale = 3.0
	anim_player.play_backwards("fade_in")
	await anim_player.animation_finished
	anim_player.speed_scale = 1.0
	get_tree().change_scene_to_file(target_path)
	
	anim_player.play("fade_in")
	
