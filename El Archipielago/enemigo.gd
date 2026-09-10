extends CharacterBody3D

@export var vida = 100
@export var gravedad = 9.8
@export var velocidad = 0.6

@onready var animation_player = $AnimationPlayer

var muerto = false
var jugador: Node3D = null

func _ready() -> void:
	var root = get_tree().current_scene
	jugador = root.find_child("Player", true, false) as Node3D

func _physics_process(delta: float) -> void:
	if muerto:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if jugador:
		var pos_jugador = jugador.global_transform.origin
		var direccion = (pos_jugador - global_transform.origin)
		direccion.y = 0
		
		if direccion.length() > 0.1:
			direccion = direccion.normalized()
			velocity.x = direccion.x * velocidad
			velocity.z = direccion.z * velocidad
			look_at(Vector3(pos_jugador.x, global_transform.origin.y, pos_jugador.z), Vector3.UP)
		else:
			velocity.x = 0
			velocity.z = 0
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func take_damage(daño):
	if muerto:
		return
	vida -= daño
	if vida <= 0:
		vida = 0
		morir()
	else:
		animation_player.play("golpe")
	$SubViewport/ProgressBar.value = vida
	print("Vida: ",vida," Daño: ",daño)

func morir():
	muerto = true
	velocity = Vector3.ZERO
	animation_player.play("caer")
	
	await get_tree().create_timer(2.0).timeout
	queue_free()
