  # boon_pickup.gd
extends Area2D
@export var boon: Boon

func _on_body_entered(body: Node2D) -> void:
	if body.has_node("BoonManager"):
		var mgr: BoonManager = body.get_node("BoonManager")
		mgr.discover_boon(boon)
		queue_free()
