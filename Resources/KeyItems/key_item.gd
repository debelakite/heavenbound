# key_item.gd
extends Resource
class_name KeyItem

@export var id: String = ""              # e.g. "simple_key", "kings_brand"
@export var display_name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var is_consumed_on_use: bool = true  # false for permanent key items like King's Brand
