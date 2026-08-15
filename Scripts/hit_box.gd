extends Area2D
class_name HitBox

var hit = false
#Upon object creation, make the hit_box disabled
func _ready() -> void:
	set_active(false)
	hit = false
	
#Enable the hit box when needed
func set_active(state: bool):
	for child in get_children():
		if child is not CollisionShape2D: continue
		
		child.disabled = not state

#If an area is entered, deal damage and register hit
func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		hit = true
		area.get_damage(1)
