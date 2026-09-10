extends Area3D

@export var velocidad = 40.0

func _ready() -> void:
	crear_temporizador_autodestruccion()

func _physics_process(delta: float) -> void:
	global_translate(-global_transform.basis.z * velocidad * delta)

func crear_temporizador_autodestruccion() -> void:
	await get_tree().create_timer(3.0).timeout
	queue_free()
