extends Label

@export var enemy: Enemy

func _ready() -> void:
	if enemy == null:
		enemy = get_parent() as Enemy
	if enemy:
		enemy.health_changed.connect(_on_health_changed)
		call_deferred("_set_initial_text")

func _set_initial_text() -> void:
	text = str(enemy.current_health) + " / " + str(enemy.max_health)

func _on_health_changed(current: int, max: int) -> void:
	text = str(current) + " / " + str(max)
