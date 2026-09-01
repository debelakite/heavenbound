# key_item_ui.gd (as a page)
extends Control
class_name KeyItemUI

@export var item_list_container: VBoxContainer
@export var item_row_scene: PackedScene

var _bound_inventory: KeyItemInventory = null

func bind_to_inventory(inv: KeyItemInventory) -> void:
	_bound_inventory = inv
	inv.key_item_count_changed.connect(_on_count_changed)
	_refresh()

func on_page_shown() -> void:
	_refresh()  # called automatically when tabbed into

func _refresh() -> void:
	for child in item_list_container.get_children():
		child.queue_free()
	if _bound_inventory == null:
		return
	for entry in _bound_inventory.get_all_held_items():
		var row = item_row_scene.instantiate()
		item_list_container.add_child(row)
		row.set_item(entry["item"], entry["count"])

func _on_count_changed(_item: KeyItem, _new_count: int) -> void:
	_refresh()
