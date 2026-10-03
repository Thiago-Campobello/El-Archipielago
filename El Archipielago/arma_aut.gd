extends Node3D
var hud: CanvasLayer
var balas=60
var balasmax=60
var cargador=220
var firecoldw=0.1
var posicion_original: Vector3
var apuntadoarma=Vector3(-0.07,-0.29,-0.87)
var punto_disparo: Marker3D = null
var bala_escena = preload("res://BALA.tscn")
var moviendo=true
var str1= str(balas)+" / "+str(balasmax)
var str2= str(cargador)
@onready var camara=get_parent().get_parent()
func _ready() -> void:
	posicion_original=position
	punto_disparo = find_child("Muzzle", true, false) as Marker3D
	var nodo_hud = get_tree().root.find_child("HUD", true, false)
	hud=nodo_hud
func _process(delta):
	if !visible or !get_parent().visible:
		return
	var camara_actual = get_viewport().get_camera_3d()
	if Input.is_action_pressed("apuntar") && camara_actual==camara:
		moviendo=false
		if visible:
			position=position.lerp(apuntadoarma,10.0*delta)
	if Input.is_action_just_released("apuntar") || moviendo==true:
		moviendo=true
		position=position.lerp(posicion_original,10*delta)
	var centro = get_viewport().get_visible_rect().size / 2
	var origen = camara_actual.project_ray_origin(centro)
	var direccion = camara_actual.project_ray_normal(centro)
	var punto_objetivo = origen + direccion * 1000.0
	$RayCast3D.target_position = $RayCast3D.to_local(punto_objetivo)
	$RayCast3D.force_raycast_update()
	if Input.is_action_pressed("shoot"):
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
			str1= str(balas)+" / "+str(balasmax)
			str2= str(cargador)
			hud.actualizar_balas(str1,str2)
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
			str1= str(balas)+" / "+str(balasmax)
			str2= str(cargador)
			hud.actualizar_balas(str1,str2)
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
