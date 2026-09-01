extends CanvasLayer

@onready var zeal_meter: ZealMeterUI = $ZealMeterUi
var player: Player = null

func _ready() -> void:
	# If you want the HUD to find the player automatically on startup:
	_find_player_in_tree()
	

## Fallback function to locate the player if it's already in the scene tree
func _find_player_in_tree() -> void:
	# Looks for a node of class "Player" or named "Player" in the current level
	var found_player = get_tree().get_first_node_in_group("player")
	if not found_player:
		# Alternative: search by scene tree path if you don't use groups
		found_player = get_tree().root.find_child("Player", true, false)
		
	if found_player:
		register_player(found_player)

func register_player(p: Node) -> void:
	player = p
	var meter = player.get_node("ZealMeter")
	

	if zeal_meter:
		zeal_meter.bind_to_meter(meter)
		if not meter.charge_changed.is_connected(zeal_meter._on_charge_changed):
			meter.charge_changed.connect(zeal_meter._on_charge_changed)

	%HealthBarUI.bind_to_health(player)




func _process(_delta: float) -> void:
	# Added a safety check to prevent crash if player is null on frame 1
	if player and player.get("dash_cooldown") and player.dash_cooldown > 0.0:
		# update dash cooldown indicator using player.dash_cooldown_timer / player.dash_cooldown
		pass
