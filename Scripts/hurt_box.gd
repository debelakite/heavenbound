class_name HurtBox extends Area2D


signal hurt()
signal died()

@export var healthPoints = 3

#Handle the damage to the hurtbox
func get_damage(value: int) :
	healthPoints -= value
	hurt.emit()
	
	if healthPoints <= 0:
		print("Hellhound has died.")
		died.emit()
