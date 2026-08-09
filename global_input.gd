extends Node

# Escape key returns to main menu
const MAIN_MENU_PATH = "res://main_menu.tscn"

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file(MAIN_MENU_PATH)
