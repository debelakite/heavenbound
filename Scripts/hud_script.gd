extends CanvasLayer

@onready var zeal_meter: ZealMeterUI = $ZealMeterUI
var player: Player = null

func _ready() -> void:
	call_deferred("find_player")

func register_player(p: Node) -> void:
	print("register_player called with: ", p)
	player = p
	var meter: ResourceMeter = player.get_node("ResourceMeter")
	print("Found meter: ", meter)
	zeal_meter.bind_to_meter(meter)

	player.health_changed.connect(_on_health_changed)

func _on_health_changed(new_stage: int) -> void:
	# update health UI
	pass

func _process(_delta: float) -> void:
	if player and player.dash_cooldown > 0.0:
		# update dash cooldown indicator using player.dash_cooldown_timer / player.dash_cooldown
		pass
		
		
