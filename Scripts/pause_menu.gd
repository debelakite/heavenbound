extends CanvasLayer

@onready var resume_button: Button = $VBoxContainer/Resume
@onready var options_button: Button = $VBoxContainer/Options
@onready var quit_button: Button = $"VBoxContainer/QuitToMenu"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # keeps this node working even while the game is paused
	visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	if get_tree().paused:
		_resume()
	else:
		_pause()

func _pause() -> void:
	get_tree().paused = true
	visible = true

func _resume() -> void:
	get_tree().paused = false
	visible = false

func _on_resume_pressed() -> void:
	_resume()


func _on_quit_pressed() -> void:
	_resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
