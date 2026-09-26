extends Node3D
var hud: CanvasLayer
var balas=30
var balasmax=30
var cargador=100
var firecoldw=0.2
var posicion_original: Vector3
var punto_disparo: Marker3D = null
var bala_escena = preload("res://BALA.tscn")
func _ready() -> void:
	posicion_original=position
	punto_disparo = find_child("Muzzle", true, false) as Marker3D
	var nodo_hud = get_tree().root.find_child("HUD", true, false)
	hud=nodo_hud
	if nodo_hud:
		nodo_hud.slot_cambiado.connect(_on_slot_cambiado)

func _on_slot_cambiado(nombre_arma: String) -> void:
	hide()
		
	match nombre_arma:
		"PISTOLA":
			var pistola =get_parent().get_node_or_null("Arma")
			if pistola: pistola.show()
			hud.actualizar_balas(balas,balasmax,cargador)
		"SUBFUSIL":
			var subfusil =get_parent().get_parent().get_node_or_null("Arma_aut")
			if subfusil: subfusil.show()

func _process(delta):
	position = position.lerp(posicion_original, 10.0 * delta)
	if visible:
		var camara_actual = get_viewport().get_camera_3d()
		var centro = get_viewport().get_visible_rect().size / 2
		var origen = camara_actual.project_ray_origin(centro)
		var direccion = camara_actual.project_ray_normal(centro)
		var punto_objetivo = origen + direccion * 1000.0
		$RayCast3D.target_position = $RayCast3D.to_local(punto_objetivo)
		$RayCast3D.force_raycast_update()
		if Input.is_action_just_pressed("shoot"):
				shoot()
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
func shoot():
	if !$FireCooldown.is_stopped():
		return
	var mult=1
	if Input.is_action_pressed("apuntar") && get_viewport().get_camera_3d()==get_parent().get_parent():
		position.z += 0.03
	else:
		position.z += 0.2
	if balas>0:
			balas-=1
			hud.actualizar_balas(balas,balasmax,cargador)
			var nueva_bala = bala_escena.instantiate()
			get_tree().current_scene.add_child(nueva_bala)
			nueva_bala.global_transform = punto_disparo.global_transform
			var ray=get_node("RayCast3D")
			if ray.is_colliding():
				var hitbox = ray.get_collider()
				var enemy = hitbox.get_parent()
				if enemy is CharacterBody3D:
					if hitbox.name=="Cabeza":
						mult=2
					enemy.take_damage(20  *mult)
	$FireCooldown.wait_time=firecoldw
	$FireCooldown.start()
