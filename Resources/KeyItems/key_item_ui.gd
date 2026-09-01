# key_item_ui.gd
extends Control
class_name KeyItemUI

@export var item_list_container: VBoxContainer  # or GridContainer for icons
@export var item_row_scene: PackedScene           # small scene: icon + name + count label

var _bound_inventory: KeyItemInventory = null

func bind_to_inventory(inv: KeyItemInventory) -> void:
	_bound_inventory = inv
	inv.key_item_count_changed.connect(_on_count_changed)
	_refresh()

func _refresh() -> void:
	for child in item_list_container.get_children():
		child.queue_free()

	for entry in _bound_inventory.get_all_held_items():
		var row = item_row_scene.instantiate()
		item_list_container.add_child(row)
		row.set_item(entry["item"], entry["count"])

func _on_count_changed(_item: KeyItem, _new_count: int) -> void:
	_refresh()

func open() -> void:
	visible = true
	_refresh()

func close() -> void:
	visible = false
