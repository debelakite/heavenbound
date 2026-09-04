# boon.gd
extends Resource
class_name Boon

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var display_icon: Texture2D
@export var notch_cost: int = 1

@export_group("Effects")
@export var heal_speed_multiplier: float = 1.0     # Quick Focus-equivalent
@export var damage_multiplier: float = 1.0          # Fragile Strength-equivalent
@export var max_health_bonus: int = 0                # Fragile/Unbreakable Heart-equivalent
@export var zeal_gain_multiplier: float = 1.0       # Soul Catcher-equivalent
@export var passive_zeal_regen: bool = false   # e.g. "Soul Catcher"-equivalent
@export var grants_zeal_from_kills: bool = false
