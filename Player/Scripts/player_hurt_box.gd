extends Area2D
class_name PlayerHurtBox


@export var owner_player: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player_hurtbox")
	
	if owner_player == null:
		owner_player = get_parent() as Player

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
