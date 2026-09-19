extends CharacterBody3D
@export var hud: CanvasLayer
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var vida=100
var vidamax=100
var muerto = false

@onready var camara_1p: Camera3D = $Camara/Camara1p
@onready var camara_3p: Camera3D = $Camara/SpringArm3D/Camera3p
var en_primera_persona: bool = false

func _ready():
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
	
func _input(_event):
	if muerto: return
	if Input.is_action_just_pressed("alt_camara"):
		alternar_perspectiva()
func alternar_perspectiva():
	en_primera_persona = !en_primera_persona
	if en_primera_persona:
		camara_1p.make_current()
	else:
		camara_3p.make_current()

func _process(_delta: float) -> void:
		hud.actualizar_vida(vida,vidamax)


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
	print("Has muerto")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if has_node("Camara/Camara1p/Arma"):
		$Camara/Camara1p/Slot2/Arma.set_process(false)
		$Camara/Camara1p/Slot2/Arma.set_physics_process(false)
		$Camara/Camara1p/Slot2/Arma.set_process_input(false)
		
	if has_node("Camara/Camara1p/Arma_aut"):
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
