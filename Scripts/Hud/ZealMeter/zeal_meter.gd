extends Control
class_name ZealMeterUI
## Zeal meter UI — attach to a Control node containing a
## TextureProgressBar (and optionally a Label for numeric display).
## Lives inside your global HUD autoload's scene tree.

@export var progress_bar: TextureProgressBar
@export var value_label: Label  # optional, e.g. "65/100"

@export_group("Feel")
@export var lerp_speed: float = 6.0          # smooth fill interpolation
@export var pulse_on_full: bool = true
@export var flash_on_denied: bool = true
@export var flash_color: Color = Color(1.0, 0.85, 0.3)  # golden flash

var _target_value: float = 0.0
var _base_modulate: Color

func _ready() -> void:
	_base_modulate = progress_bar.modulate
	progress_bar.fill_mode = TextureProgressBar.FILL_BOTTOM_TO_TOP
	progress_bar.min_value = 0.0
	progress_bar.value = 0.0

func _process(delta: float) -> void:
	# Smoothly animate toward target instead of snapping — reads as
	# "charge flowing in" rather than a jump cut.
	if not is_equal_approx(progress_bar.value, _target_value):
		progress_bar.value = lerp(progress_bar.value, _target_value, lerp_speed * delta)
		if abs(progress_bar.value - _target_value) < 0.05:
			progress_bar.value = _target_value


## Call this once, wherever the HUD wires itself up to the player's
## ResourceMeter node (e.g. when the player spawns/is assigned).
func bind_to_meter(meter: ResourceMeter) -> void:
	progress_bar.max_value = meter.max_charge
	_target_value = meter.current_charge
	progress_bar.value = meter.current_charge
	_update_label(meter.current_charge, meter.max_charge)

	meter.charge_changed.connect(_on_charge_changed)
	meter.charge_full.connect(_on_charge_full)
	meter.insufficient_charge.connect(_on_insufficient_charge)


func _on_charge_changed(current: float, max: float) -> void:
	progress_bar.max_value = max
	_target_value = current
	_update_label(current, max)

func _update_label(current: float, max: float) -> void:
	if value_label:
		value_label.text = "%d/%d" % [floor(current), int(max)]

func _on_charge_full() -> void:
	if pulse_on_full:
		_pulse()

func _on_insufficient_charge(_required: float, _available: float) -> void:
	if flash_on_denied:
		_flash_deny()


# ---------- Juice ----------

func _pulse() -> void:
	var tween := create_tween()
	tween.tween_property(progress_bar, "scale", Vector2(1.08, 1.08), 0.12)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(progress_bar, "scale", Vector2.ONE, 0.18)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _flash_deny() -> void:
	var tween := create_tween()
	tween.tween_property(progress_bar, "modulate", flash_color, 0.06)
	tween.tween_property(progress_bar, "modulate", _base_modulate, 0.25)
