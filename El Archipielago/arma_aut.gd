extends Node3D
var hud: CanvasLayer
var balas=60
var balasmax=60
var cargador=220
var firecoldw=0.1
var posicion_original: Vector3
var punto_disparo: Marker3D = null
var bala_escena = preload("res://BALA.tscn")
func _ready() -> void:
	posicion_original=position
	punto_disparo = find_child("Muzzle", true, false) as Marker3D
func _input(event):
	if visible:
		if Input.is_action_just_pressed("reload"):
			if balas<balasmax:
				var a=balasmax-balas
				if cargador>a && cargador>0:
					balas+=a
					cargador-=a
				elif cargador>0:
					balas+=cargador
					cargador=0
			hud.actualizar_balas(balas,balasmax,cargador)
func _process(delta):
	if Input.is_action_pressed("shoot"):
		if visible:
			shoot()
	position = position.lerp(posicion_original, 10.0 * delta)
func shoot():
	if !$FireCooldown.is_stopped():
		return
	var mult=1
	position.z += 0.2
	if balas>0:
			balas-=1
			hud.actualizar_balas(balas,balasmax,cargador)
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
