extends Control

# Play redirects to the scene
const GAME_SCENE_PATH = "res://Scenes/RoomOne.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Hud.visible = false
	$VBoxContainer/ButtonPlay.pressed.connect(_on_button_play_pressed)
	$VBoxContainer/ButtonQuit.pressed.connect(_on_button_quit_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_play_pressed() -> void:
	Hud.visible = true
	get_tree().change_scene_to_file(GAME_SCENE_PATH)

func _on_button_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
	
