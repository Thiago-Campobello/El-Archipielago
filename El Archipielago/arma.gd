extends Node3D
var balas=30
var cargador=100
var firecoldw=0.2
func _input(event):
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		if balas<30:
			var a=30-balas
			if cargador>a:
				balas+=a
				cargador-=a
			else:
				var b=a-cargador
				balas+=b
				cargador-=b
func shoot():
	if !$FireCooldown.is_stopped():
		return
	var mult=1
	if balas>0:
			balas-=1
			var ray=$RayCast3D
			if ray.is_colliding():
				var hitbox = ray.get_collider()
				var enemy = hitbox.get_parent()
				if enemy is CharacterBody3D:
					if hitbox.name=="Cabeza":
						mult=2
					enemy.take_damage(20  *mult)
	$FireCooldown.wait_time=firecoldw
	$FireCooldown.start()
