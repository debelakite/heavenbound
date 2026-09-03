# item_row.gd
extends HBoxContainer

func set_item(item: KeyItem, count: int) -> void:
	$Icon.texture = item.icon
	$NameLabel.text = item.display_name
