extends Node3D
var balas=30
var cargador=100
var firecoldw=0.2
var posicion_original: Vector3
var punto_disparo: Marker3D = null
var bala_escena = preload("res://BALA.tscn")
func _ready() -> void:
	posicion_original=position
	punto_disparo = find_child("Muzzle", true, false) as Marker3D
func _input(event):
	if Input.is_action_pressed("shoot"):
		if visible:
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
func _process(delta):
	position = position.lerp(posicion_original, 10.0 * delta)
func shoot():
	if !$FireCooldown.is_stopped():
		return
	var mult=1
	position.z += 0.2
	if balas>0:
			balas-=1
			if bala_escena and punto_disparo:
				var nueva_bala = bala_escena.instantiate()
				get_tree().current_scene.add_child(nueva_bala)
				nueva_bala.global_transform = punto_disparo.global_transform
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
