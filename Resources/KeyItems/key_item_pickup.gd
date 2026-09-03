# key_item_pickup.gd
extends Area2D

@export var item: KeyItem
@export var quantity: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.has_node("KeyItemInventory"):
		var inv: KeyItemInventory = body.get_node("KeyItemInventory")
		inv.add_key_item(item, quantity)
		# optional: play pickup sound/effect, show a "Simple Key acquired" popup
		queue_free()
