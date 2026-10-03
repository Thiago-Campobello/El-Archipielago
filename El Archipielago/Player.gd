extends CharacterBody3D

const SPEED := 5.0
const JUMP_VELOCITY := 4.5
const RUN_MULTIPLIER := 1.5
const OBJECT_HOLD_DISTANCE := 2.5
const OBJECT_HOLD_HEIGHT := 1.5
const OBJECT_HOLD_FORCE := 15.0
const THROW_FORCE := 15.0
const WEAPON_THROW_FORCE := 2.0

signal p1
signal p3

var vida := 100
var vidamax := 100
var muerto := false

var held_object: RigidBody3D = null
var en_primera_persona := false

var pistola_escena = preload("res://PistolaFisica.tscn")
var subfusil_escena = preload("res://SubfusilFisica.tscn")

@onready var camara_1p: Camera3D = $Camara/Camara1p
@onready var camara_3p: Camera3D = $Camara/SpringArm3D/Camera3p
@onready var ray_cast: RayCast3D = $Camara/Camara1p/RayCast3D

@onready var arma_pistola = $Camara/Camara1p/Slot2/Arma
@onready var arma_subfusil = $Camara/Camara1p/Slot3/Arma

var hud: CanvasLayer


func _ready() -> void:
	hud = get_parent().get_node("HUD")
	arma_pistola.hud = hud
	arma_subfusil.hud = hud
	hud.actualizar_vida(vida, vidamax)
	camara_1p.make_current()


func _physics_process(delta: float) -> void:
	if muerto:
		velocity.x = 0.0
		velocity.z = 0.0
		return
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	mover_jugador()

	if held_object and is_instance_valid(held_object):
		actualizar_objeto_sostenido()


func mover_jugador() -> void:
	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var camara_activa := get_viewport().get_camera_3d()

	if camara_activa == null:
		return

	var forward := camara_activa.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()

	var right := camara_activa.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()

	var direction := right * input_dir.x + forward * input_dir.y

	if direction != Vector3.ZERO:
		direction = direction.normalized()

		var velocidad := SPEED

		if Input.is_action_pressed("run") and is_on_floor():
			velocidad *= RUN_MULTIPLIER

		velocity.x = direction.x * velocidad
		velocity.z = direction.z * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)

	move_and_slide()

func actualizar_objeto_sostenido() -> void:
	var direccion_frente := -global_transform.basis.z

	var target_pos := (
		global_position
		+ Vector3.UP * OBJECT_HOLD_HEIGHT
		+ direccion_frente * OBJECT_HOLD_DISTANCE
	)

	var diferencia := target_pos - held_object.global_position

	held_object.linear_velocity = diferencia * OBJECT_HOLD_FORCE
	held_object.angular_velocity = Vector3.ZERO


func _input(_event: InputEvent) -> void:
	if muerto:
		return

	if Input.is_action_just_pressed("alt_camara"):
		alternar_pers_func()

	if Input.is_action_just_pressed("interactuar"):
		if held_object:
			drop_object()
		else:
			try_grab_object()

	if Input.is_action_just_pressed("tirar"):
		if held_object:
			throw_object()
		else:
			throw_active_weapon()


func alternar_pers_func() -> void:
	en_primera_persona = !en_primera_persona

	if en_primera_persona:
		camara_1p.make_current()
		p1.emit()
	else:
		camara_3p.make_current()
		p3.emit()


func _process(_delta: float) -> void:
	if muerto or hud == null:
		return

	mostrar_interaccion()


func mostrar_interaccion() -> void:
	if held_object or not ray_cast.is_colliding():
		hud.ocultar_mensaje_interactuar()
		return

	var collider = ray_cast.get_collider()

	if collider == null or not collider.has_method("interactuar"):
		hud.ocultar_mensaje_interactuar()
		return

	if "nombre_objeto" in collider:
		hud.mostrar_mensaje_interactuar(
			"[E] Agarrar " + str(collider.nombre_objeto)
		)
	else:
		hud.mostrar_mensaje_interactuar("[E] Interactuar")


func try_grab_object() -> void:
	ray_cast.force_raycast_update()

	if not ray_cast.is_colliding():
		return

	var collider = ray_cast.get_collider()

	if collider == null:
		return

	if collider.has_method("interactuar"):
		collider.interactuar(self)
		return

	if collider is RigidBody3D:
		held_object = collider
		held_object.gravity_scale = 0.0


func drop_object() -> void:
	if not is_instance_valid(held_object):
		held_object = null
		return

	held_object.gravity_scale = 1.0
	held_object = null


func throw_object() -> void:
	if not is_instance_valid(held_object):
		held_object = null
		return

	var objeto := held_object
	held_object = null

	objeto.gravity_scale = 1.0

	var direccion_frente := -global_transform.basis.z
	objeto.apply_central_impulse(direccion_frente * THROW_FORCE)


func throw_active_weapon() -> void:
	if hud == null:
		return

	var slot = hud.slot_seleccionado

	var nodo_arma_mano = null
	var escena_a_crear: PackedScene = null

	match slot:
		1:
			nodo_arma_mano = arma_pistola
			escena_a_crear = pistola_escena

		2:
			nodo_arma_mano = arma_subfusil
			escena_a_crear = subfusil_escena

		_:
			return

	if not hud.conseguidos[slot]:
		return

	var arma_fisica = escena_a_crear.instantiate()
	get_tree().current_scene.add_child(arma_fisica)
	arma_fisica.configurar_desde_arma(nodo_arma_mano)
	var direccion_frente := -global_transform.basis.z

	arma_fisica.global_position = (
		global_position
		+ Vector3(0, 1.2, 0)
		+ direccion_frente * 0.8
	)

	if arma_fisica is RigidBody3D:
		arma_fisica.freeze = false
		arma_fisica.sleeping = false
		arma_fisica.apply_central_impulse(
			direccion_frente * WEAPON_THROW_FORCE
		)

	nodo_arma_mano.hide()

	hud.quitar_arma_inventario(hud.nombres[slot])

func take_damage(daño: int) -> void:
	if muerto:
		return

	vida = max(vida - daño, 0)

	if hud:
		hud.actualizar_vida(vida, vidamax)

	if vida == 0:
		morir()


func morir() -> void:
	if muerto:
		return

	muerto = true

	print("Has muerto")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if held_object:
		drop_object()

	desactivar_arma(arma_pistola)
	desactivar_arma(arma_subfusil)

	mostrar_pantalla_muerte()


func desactivar_arma(arma: Node) -> void:
	arma.set_process(false)
	arma.set_physics_process(false)
	arma.set_process_input(false)


func mostrar_pantalla_muerte() -> void:
	var centro := CenterContainer.new()
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	centro.grow_horizontal = Control.GROW_DIRECTION_BOTH
	centro.grow_vertical = Control.GROW_DIRECTION_BOTH

	var contenedor := VBoxContainer.new()
	centro.add_child(contenedor)

	var cartel := Label.new()
	cartel.text = "HAS MUERTO"
	cartel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cartel.add_theme_font_size_override("font_size", 48)
	cartel.add_theme_color_override("font_color", Color.RED)
	contenedor.add_child(cartel)

	var boton := Button.new()
	boton.text = "Reintentar"
	boton.add_theme_font_size_override("font_size", 24)
	boton.pressed.connect(_on_reintentar_pressed)
	contenedor.add_child(boton)

	if hud:
		hud.add_child(centro)


func _on_reintentar_pressed() -> void:
	get_tree().reload_current_scene()
