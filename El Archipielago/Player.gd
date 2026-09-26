extends CharacterBody3D
var hud: CanvasLayer
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var vida=100
var vidamax=100
var muerto = false
signal p1
signal p3
@onready var camara_1p: Camera3D = $Camara/Camara1p
@onready var camara_3p: Camera3D = $Camara/SpringArm3D/Camera3p
var en_primera_persona: bool = false

@onready var ray_cast = $Camara/Camara1p/RayCast3D

var held_object: RigidBody3D = null
var pistola_escena = preload("res://PistolaFisica.tscn")
var subfusil_escena = preload("res://SubfusilFisica.tscn")

func _ready():
	hud = get_tree().current_scene.find_child("HUD", true, false)

	$Camara/Camara1p/Slot3/Arma_aut.hud=hud
	$Camara/Camara1p/Slot2/Arma.hud=hud
	hud.actualizar_vida(vida,vidamax)
	hud.actualizar_balas($Camara/Camara1p/Slot2/Arma.balas,$Camara/Camara1p/Slot2/Arma.balasmax,$Camara/Camara1p/Slot2/Arma.cargador)
	
	en_primera_persona = false
	camara_1p.make_current()

func _physics_process(delta: float) -> void:
	if muerto:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("move_left","move_right","move_forward","move_backward")
	
	var camara_activa = get_viewport().get_camera_3d()
	var forward = camara_activa.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	var right = camara_activa.global_transform.basis.x
	right.y = 0
	right = right.normalized()
	
	var direction = right * input_dir.x + forward * input_dir.y
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_pressed("run") && is_on_floor():
		velocity.z*=1.5
		velocity.x*=1.5
	move_and_slide()
	
	if held_object:
		var direccion_frente = -global_transform.basis.z
		var target_pos = global_position + Vector3(0, 1.5, 0) + (direccion_frente * 2.5)
		var current_pos = held_object.global_position
		held_object.linear_velocity = (target_pos - current_pos) * 15.0
		held_object.angular_velocity = Vector3.ZERO
	
func _input(_event):
	if muerto: return
	if Input.is_action_just_pressed("alt_camara"):
		alternar_pers_func()
		
	if Input.is_action_just_pressed("interactuar"):
		if held_object:
			drop_object()
		else:
			try_grab_object()
			
	if Input.is_action_just_pressed("tirar") and held_object:
		throw_object()
	elif Input.is_action_just_pressed("tirar") and not held_object:
		throw_active_weapon()

func alternar_pers_func():
	en_primera_persona = !en_primera_persona
	if en_primera_persona:
		camara_1p.make_current()
		emit_signal("p1")
	else:
		camara_3p.make_current()
		emit_signal("p3")

func _process(_delta: float) -> void:
	if hud:
		hud.actualizar_vida(vida,vidamax)
	
	if not muerto and ray_cast.is_colliding() and not held_object:
		var collider = ray_cast.get_collider()
		if collider and collider.has_method("interactuar"):
			if "nombre_objeto" in collider:
				hud.mostrar_mensaje_interactuar("[E] Agarrar " + collider.nombre_objeto)
			else:
				hud.mostrar_mensaje_interactuar("[E] Interactuar")
		else:
			if hud:
				hud.ocultar_mensaje_interactuar()
	else:
		if hud:
			hud.ocultar_mensaje_interactuar()

func take_damage(daño: int):
	if muerto:
		return
		
	vida -= daño
	if vida <= 0:
		vida = 0
		morir()
	
	if hud:
		hud.actualizar_vida(vida, vidamax)

func morir():
	muerto = true
	("Has muerto")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if held_object:
		drop_object()
	
	if has_node("Camara/Camara1p/Slot2/Arma"):
		$Camara/Camara1p/Slot2/Arma.set_process(false)
		$Camara/Camara1p/Slot2/Arma.set_physics_process(false)
		$Camara/Camara1p/Slot2/Arma.set_process_input(false)
		
	if has_node("Camara/Camara1p/Slot3/Arma_aut"):
		$Camara/Camara1p/Slot3/Arma_aut.set_process(false)
		$Camara/Camara1p/Slot3/Arma_aut.set_physics_process(false)
		$Camara/Camara1p/Slot3/Arma_aut.set_process_input(false)
	
	var centro = CenterContainer.new()
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	centro.grow_horizontal = Control.GROW_DIRECTION_BOTH
	centro.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	var contenedor = VBoxContainer.new()
	centro.add_child(contenedor)
	
	var cartel = Label.new()
	cartel.text = "HAS MUERTO"
	cartel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cartel.add_theme_font_size_override("font_size", 48)
	cartel.add_theme_color_override("font_color", Color.RED)
	contenedor.add_child(cartel)
	
	var boton = Button.new()
	boton.text = "Reintentar"
	boton.add_theme_font_size_override("font_size", 24)
	boton.pressed.connect(_on_reintentar_pressed)
	contenedor.add_child(boton)
	
	if hud:
		hud.add_child(centro)

func _on_reintentar_pressed():
	get_tree().reload_current_scene()

func try_grab_object():
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider and collider.has_method("interactuar"):
			collider.interactuar(self)
		elif collider is RigidBody3D:
			held_object = collider
			held_object.gravity_scale = 0.0

func drop_object():
	if held_object:
		held_object.gravity_scale = 1.0
		held_object = null

func throw_object():
	if held_object:
		held_object.gravity_scale = 1.0
		var throw_direction = -global_transform.basis.z
		held_object.apply_central_impulse(throw_direction * 15.0)
		held_object = null

func throw_active_weapon():
	var nodo_arma_mano = null
	var slot_id = 0
	var escena_a_crear = null
	
	if $Camara/Camara1p/Slot2/Arma.visible:
		nodo_arma_mano = $Camara/Camara1p/Slot2/Arma
		slot_id = 2
		escena_a_crear = pistola_escena
	elif $Camara/Camara1p/Slot3/Arma_aut.visible:
		nodo_arma_mano = $Camara/Camara1p/Slot3/Arma_aut
		slot_id = 3
		escena_a_crear = subfusil_escena
		
	if nodo_arma_mano != null and escena_a_crear != null:
		var arma_fisica = escena_a_crear.instantiate()
		get_tree().current_scene.add_child(arma_fisica)
		
		if arma_fisica is RigidBody3D:
			arma_fisica.freeze = false
			arma_fisica.sleeping = false
		
		var direccion_frente = -global_transform.basis.z
		arma_fisica.global_position = global_position + Vector3(0, 1.2, 0) + (direccion_frente * 0.8)
		arma_fisica.apply_central_impulse(direccion_frente * 2.0)
		
		nodo_arma_mano.visible = false
		
		if hud:
			hud.inventario_slots[slot_id]["conseguido"] = false
			hud.actualizar_nombres_inventario()
			hud.actualizar_balas(0, nodo_arma_mano.balasmax, 0)
