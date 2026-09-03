# key_item_inventory.gd
extends Node
class_name KeyItemInventory
## Attach as a child node on the player, alongside ZealMeter.

signal key_item_added(item: KeyItem, quantity: int)
signal key_item_used(item: KeyItem)
signal key_item_count_changed(item: KeyItem, new_count: int)

# id -> { "item": KeyItem, "count": int }
var _held_items: Dictionary = {}

func add_key_item(item: KeyItem, quantity: int = 1) -> void:
	if not _held_items.has(item.id):
		_held_items[item.id] = {"item": item, "count": 0}
	_held_items[item.id]["count"] += quantity

	key_item_added.emit(item, quantity)
	key_item_count_changed.emit(item, _held_items[item.id]["count"])


func get_count(item: KeyItem) -> int:
	if _held_items.has(item.id):
		return _held_items[item.id]["count"]
	return 0


func has_key_item(item: KeyItem) -> bool:
	return get_count(item) > 0


## Call this from whatever the key item unlocks (a locked door, chest, etc.)
func try_use_key_item(item: KeyItem) -> bool:
	if not has_key_item(item):
		return false

	if item.is_consumed_on_use:
		_held_items[item.id]["count"] -= 1
		key_item_count_changed.emit(item, _held_items[item.id]["count"])

	key_item_used.emit(item)
	return true


func get_all_held_items() -> Array:
	var result := []
	for entry in _held_items.values():
		if entry["count"] > 0:
			result.append(entry)
	return result
