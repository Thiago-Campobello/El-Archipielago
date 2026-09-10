extends CharacterBody3D

@export var vida = 100
@export var gravedad = 9.8

@onready var animation_player = $AnimationPlayer

var muerto = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
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

func morir():
	muerto = true
	animation_player.play("caer")
