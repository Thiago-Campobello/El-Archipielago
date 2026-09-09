extends CharacterBody3D
@export var vida=100
func take_damage(daño):
	if daño>vida:
		vida=0
	else:
		vida-=daño
