extends CanvasLayer

@onready var zeal_meter: ZealMeterUI = $ZealMeterUI
var player: Player = null

func _ready() -> void:
	call_deferred("find_player")

func find_player() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_warning("ZealMeterUI: no player found in 'player' group yet")
		return

	var meter: ResourceMeter = player.get_node("ResourceMeter")
	zeal_meter.bind_to_meter(meter)
	player.health_changed.connect(_on_health_changed)

func _on_health_changed(new_stage: int) -> void:
	# update health UI
	pass

func _process(_delta: float) -> void:
	if player and player.dash_cooldown > 0.0:
		# update dash cooldown indicator using player.dash_cooldown_timer / player.dash_cooldown
		pass
		
		
