extends TextureProgressBar

func _ready() -> void:
	call_deferred("connect_player")

func connect_player() -> void:
	var player := get_tree().get_first_node_in_group("player") as Player
	#if player:
	#	max_value = player.max_resource
		#value = player.current_resource
		#player.resource_changed.connect(_on_resource_changed)

func _on_resource_changed(current: float, max: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "value", current, 0.25).set_trans(Tween.TRANS_SINE)
