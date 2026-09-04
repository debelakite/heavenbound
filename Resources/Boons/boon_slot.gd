extends Button
class_name BoonSlot

@onready var icon_display: TextureRect = $Icon  # renamed variable to avoid clashing with Button.icon

var _boon: Boon

func set_boon(boon: Boon, equipped: bool) -> void:
	_boon = boon
	icon_display.texture = boon.display_icon
	modulate = Color.WHITE if equipped else Color(0.5, 0.5, 0.5)
	tooltip_text = boon.display_name + "\n" + boon.description
	print("Tooltip set to: ", tooltip_text)
