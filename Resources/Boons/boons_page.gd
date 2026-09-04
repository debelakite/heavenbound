# boons_page.gd
extends Control
class_name BoonsPage

@export var owned_grid: GridContainer
@export var boon_slot_scene: PackedScene
@export var notch_label: Label

var _bound_boon_manager: BoonManager = null

func bind_to_boon_manager(mgr: BoonManager) -> void:
	_bound_boon_manager = mgr
	mgr.notches_changed.connect(_on_notches_changed)
	mgr.boon_equipped.connect(_on_loadout_changed)
	mgr.boon_unequipped.connect(_on_loadout_changed)
	mgr.equip_failed.connect(func(boon, reason): print("Equip failed: ", reason))
	_refresh()

func on_page_shown() -> void:
	_refresh()

func _refresh() -> void:
	for child in owned_grid.get_children():
		child.queue_free()
	if _bound_boon_manager == null:
		return
	for boon in _bound_boon_manager.owned_boons:
		var slot = boon_slot_scene.instantiate()
		owned_grid.add_child(slot)
		slot.set_boon(boon, _bound_boon_manager.is_equipped(boon))
		slot.pressed.connect(_on_boon_slot_pressed.bind(boon))
	_update_notch_label()

func _on_boon_slot_pressed(boon: Boon) -> void:
	if _bound_boon_manager.is_equipped(boon):
		_bound_boon_manager.unequip_boon(boon)
	else:
		_bound_boon_manager.equip_boon(boon)

func _update_notch_label() -> void:
	notch_label.text = "%d / %d Notches" % [_bound_boon_manager.get_used_notches(), _bound_boon_manager.max_notches]

func _on_notches_changed(_used: int, _max: int) -> void:
	_update_notch_label()

func _on_loadout_changed(_boon: Boon) -> void:
	_refresh()
