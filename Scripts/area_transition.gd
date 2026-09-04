class_name AreaTransition extends Area2D

# The target scene file to load when entering this area
@export_file("*.tscn") var target_scene: String

# Spawn point identifier for the next scene
@export var spawn_point_id: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if target_scene.is_empty():
			print("ERROR: Target scene variable is empty in Inspector!")
			return
		GameState.target_spawn_id = spawn_point_id
		set_deferred("monitoring", false)
		Transition.change_scene(target_scene, spawn_point_id)
