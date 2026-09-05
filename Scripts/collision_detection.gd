class_name Shot
extends Node2D

@export var speed := 500
@export var lifetime := 3.0

var direction := Vector2.ZERO

@onready var _impact_detector_area: Area2D = %ImpactDetectorArea2D
@onready var _timer: Timer = %Timer


func _ready():
	_impact_detector_area.body_entered.connect(_on_impact_detector_area_body_entered)
	_timer.timeout.connect(queue_free)
	_timer.start(lifetime)

	top_level = true
	look_at(position + direction)


func _physics_process(delta: float) -> void:
	self.position += direction * speed * delta


func _on_impact_detector_area_body_entered(_body: Node2D) -> void:
	queue_free()
