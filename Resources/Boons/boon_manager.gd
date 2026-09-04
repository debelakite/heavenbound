# boon_manager.gd
extends Node
class_name BoonManager
## Attach as a child node on the player.

signal boon_equipped(boon: Boon)
signal boon_unequipped(boon: Boon)
signal notches_changed(used: int, max: int)
signal equip_failed(boon: Boon, reason: String)

@export var max_notches: int = 6

var owned_boons: Array[Boon] = []
var equipped_boons: Array[Boon] = []
var _can_modify_loadout: bool = false  # true only while resting at a bench


func discover_boon(boon: Boon) -> void:
	if boon not in owned_boons:
		owned_boons.append(boon)


func get_used_notches() -> int:
	var total := 0
	for boon in equipped_boons:
		total += boon.notch_cost
	return total


func can_equip(boon: Boon) -> bool:
	if not _can_modify_loadout:
		return false
	if boon not in owned_boons:
		return false
	if boon in equipped_boons:
		return false
	return get_used_notches() + boon.notch_cost <= max_notches


func equip_boon(boon: Boon) -> bool:
	if not _can_modify_loadout:
		equip_failed.emit(boon, "not_at_bench")
		return false
	if not can_equip(boon):
		var reason := "not_owned"
		if boon in equipped_boons:
			reason = "already_equipped"
		elif get_used_notches() + boon.notch_cost > max_notches:
			reason = "not_enough_notches"
		equip_failed.emit(boon, reason)
		return false

	equipped_boons.append(boon)
	boon_equipped.emit(boon)
	notches_changed.emit(get_used_notches(), max_notches)
	return true


func unequip_boon(boon: Boon) -> bool:
	if not _can_modify_loadout:
		return false
	if boon not in equipped_boons:
		return false

	equipped_boons.erase(boon)
	boon_unequipped.emit(boon)
	notches_changed.emit(get_used_notches(), max_notches)
	return true


func is_equipped(boon: Boon) -> bool:
	return boon in equipped_boons


## Called by the rest point when the player interacts with it.
func enter_loadout_mode() -> void:
	_can_modify_loadout = true

## Called when the player leaves the bench (walks away, closes menu, etc.)
func exit_loadout_mode() -> void:
	_can_modify_loadout = false

func get_heal_speed_multiplier() -> float:
	var result := 1.0
	for boon in equipped_boons:
		result *= boon.heal_speed_multiplier
	return result

func get_damage_multiplier() -> float:
	var result := 1.0
	for boon in equipped_boons:
		result *= boon.damage_multiplier
	return result

func get_zeal_gain_multiplier() -> float:
	var result := 1.0
	for boon in equipped_boons:
		result *= boon.zeal_gain_multiplier
	return result



#region Special Boon Checks
func has_passive_zeal_regen() -> bool:
	for boon in equipped_boons:
		if boon.passive_zeal_regen:
			return true
	return false

func has_zeal_from_kills() -> bool:
	for boon in equipped_boons:
		if boon.grants_zeal_from_kills:
			return true
	return false
#endregion
