extends Node3D
func _input(event):
	var mult=1
	if Input.is_action_just_pressed("shoot"):
		var ray=$RayCast3D
		if ray.is_colliding():
			var hitbox = ray.get_collider()
			var enemy = hitbox.get_parent()
			if enemy is CharacterBody3D:
				if hitbox.name=="Cabeza":
					mult=2
				enemy.take_damage(20  *mult)
