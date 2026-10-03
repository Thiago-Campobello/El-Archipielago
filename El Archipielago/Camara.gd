extends Node3D
var posinarma1
var posinarma2
var sensibility=0.006
var a=0.1
var moviendo=false
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	posinarma1=$Camara1p/Slot2/Arma.position
	posinarma2=$Camara1p/Slot3/Arma.position
func _process(_delta: float) -> void:
	if Input.is_action_pressed("apuntar") and get_viewport().get_camera_3d()==$Camara1p and get_parent().hud.conseguidos[get_parent().hud.slot_seleccionado] and get_parent().hud.slot_seleccionado!=0:
		moviendo=false
		if $Camara1p.fov>65:
			$Camara1p.fov=lerp(75,65,a)
			a+=0.15
			if a>1:a=0.1
		if $Camara1p.fov<65: 
			$Camara1p.fov=65
	if Input.is_action_just_released("apuntar") || moviendo==true:
		moviendo=true
		if $Camara1p.fov<75:
			$Camara1p.fov=lerp(65,75,a)
			a+=0.15
			if a>1:a=0.1
		else: if $Camara1p.fov>75: 
			$Camara1p.fov=75
func _input(event):
	if Input.is_action_just_pressed("desbq_mouse"):
			if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_released("apuntar"):
		a=0.1
	if event is InputEventMouseMotion:
		if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x*sensibility)
			$Camara1p.rotation.x -= event.relative.y*sensibility
			$Camara1p.rotation.x = clamp($Camara1p
			.rotation.x,-deg_to_rad(89),deg_to_rad(89))
