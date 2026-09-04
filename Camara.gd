extends Node3D
var sensibility=0.01
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _input(event):
	if Input.is_action_just_pressed("desbq_mouse"):
			if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion:
		if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x*sensibility)
			$Camara1p.rotation.x -= event.relative.y*sensibility
			$Camara1p.rotation.x = clamp($Camara1p.rotation.x,-deg_to_rad(89),deg_to_rad(89))
