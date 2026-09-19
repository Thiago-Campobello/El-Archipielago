extends Node3D
var posinarma1=Vector3(0.373,-0.38,-0.25)
var posinarma2=Vector3(0.373,-0.27,-0.87)
var apuntadoarma1=Vector3(-0.03,-0.38,-0.31)
var apuntadoarma2=Vector3(-0.07,-0.29,-0.87)
var sensibility=0.006
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _process(delta: float) -> void:
	if Input.is_action_pressed("apuntar") && get_viewport().get_camera_3d()==$Camara1p:
		if $Camara1p/Slot2/Arma.visible:
			$Camara1p/Slot2/Arma.position=apuntadoarma1
		if $Camara1p/Slot3/Arma_aut.visible:
			$Camara1p/Slot3/Arma_aut.position=apuntadoarma2
		$Camara1p.fov=65
func _input(event):
	if Input.is_action_just_pressed("desbq_mouse"):
			if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_released("apuntar"):
		$Camara1p.fov=75
		$Camara1p/Slot2/Arma.position=posinarma1
		$Camara1p/Slot3/Arma_aut.position=posinarma2
	if event is InputEventMouseMotion:
		if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x*sensibility)
			$Camara1p.rotation.x -= event.relative.y*sensibility
			$Camara1p.rotation.x = clamp($Camara1p
			.rotation.x,-deg_to_rad(89),deg_to_rad(89))
