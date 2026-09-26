extends CharacterBody3D

@export var vida = 100
@export var gravedad = 9.8
@export var velocidad = 1.5
@export var distancia_ataque: float = 1.5
@export var daño_hacha: int = 15
@export var tiempo_entre_ataques: float = 1.2
@export var fuerza_impulso_ataque: float = 4.0
@export var distancia_deteccion: float = 12.0
@export var nodo_hacha: Node3D

var muerto = false
var jugador: Node3D = null
var puede_atacar: bool = true
var en_impulso: bool = false
var rotacion_original_hacha: Vector3

var posicion_patrulla: Vector3
var tiempo_cambio_rumbo: float = 0.0

func _ready() -> void:
	var root = get_tree().current_scene
	jugador = root.find_child("Player", true, false) as Node3D
	
	if nodo_hacha:
		rotacion_original_hacha = nodo_hacha.rotation
	
	_elegir_nueva_direccion_patrulla()

func _physics_process(delta: float) -> void:
	if muerto:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var jugador_valido = jugador and ("muerto" in jugador and not jugador.muerto)
	
	if jugador_valido:
		var pos_jugador = jugador.global_transform.origin
		var direccion = (pos_jugador - global_transform.origin)
		var distancia = direccion.length()
		direccion.y = 0
		
		if distancia <= distancia_deteccion:
			if distancia <= distancia_ataque and puede_atacar:
				atacar_jugador(direccion)
			
			if not en_impulso:
				if direccion.length() > 0.1:
					direccion = direccion.normalized()
					velocity.x = direccion.x * velocidad
					velocity.z = direccion.z * velocidad
					
					var destino_mirada = Vector3(pos_jugador.x, global_transform.origin.y, pos_jugador.z)
					if global_transform.origin.distance_to(destino_mirada) > 0.1:
						look_at(destino_mirada, Vector3.UP)
				else:
					velocity.x = 0
					velocity.z = 0
			else:
				velocity.x = lerp(velocity.x, 0.0, delta * 10.0)
				velocity.z = lerp(velocity.z, 0.0, delta * 10.0)
		else:
			_deambular_por_mapa(delta)
	else:
		_deambular_por_mapa(delta)

	move_and_slide()

func _deambular_por_mapa(delta: float) -> void:
	tiempo_cambio_rumbo -= delta
	if tiempo_cambio_rumbo <= 0:
		_elegir_nueva_direccion_patrulla()
		
	var dir_patrulla = (posicion_patrulla - global_transform.origin)
	dir_patrulla.y = 0
	
	if dir_patrulla.length() > 0.5:
		dir_patrulla = dir_patrulla.normalized()
		velocity.x = dir_patrulla.x * (velocidad * 0.6)
		velocity.z = dir_patrulla.z * (velocidad * 0.6)
		
		var destino_mirada = Vector3(posicion_patrulla.x, global_transform.origin.y, posicion_patrulla.z)
		if global_transform.origin.distance_to(destino_mirada) > 0.1:
			look_at(destino_mirada, Vector3.UP)
	else:
		velocity.x = 0
		velocity.z = 0

func _elegir_nueva_direccion_patrulla() -> void:
	var angulo_al_azar = randf_range(0, 2 * PI)
	var rango_al_azar = randf_range(4.0, 8.0)
	posicion_patrulla = global_transform.origin + Vector3(cos(angulo_al_azar) * rango_al_azar, 0, sin(angulo_al_azar) * rango_al_azar)
	tiempo_cambio_rumbo = randf_range(3.0, 6.0)

func take_damage(daño):
	if muerto:
		return
	vida -= daño
	if vida <= 0:
		vida = 0
		morir()
	$SubViewport/ProgressBar.value = vida

func morir():
	muerto = true
	velocity = Vector3.ZERO
	
	await get_tree().create_timer(2.0).timeout
	queue_free()

func atacar_jugador(direccion_hacia_jugador: Vector3):
	puede_atacar = false
	en_impulso = true
	
	var direccion_normalizada = direccion_hacia_jugador.normalized()
	velocity.x = direccion_normalizada.x * fuerza_impulso_ataque
	velocity.z = direccion_normalizada.z * fuerza_impulso_ataque
	
	if nodo_hacha:
		nodo_hacha.rotation.z = rotacion_original_hacha.z + 1.4
	
	if jugador.has_method("recibir_daño"):
		jugador.recibir_daño(daño_hacha)
	elif jugador.has_method("take_damage"):
		jugador.take_damage(daño_hacha)
		
	await get_tree().create_timer(0.2).timeout
	en_impulso = false
	
	if nodo_hacha:
		nodo_hacha.rotation = rotacion_original_hacha
	
	await get_tree().create_timer(tiempo_entre_ataques - 0.2).timeout
	
	if not muerto:
		puede_atacar = true
