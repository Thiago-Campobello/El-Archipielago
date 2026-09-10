extends CharacterBody3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("move_left","move_right","move_forward","move_backward")
	var forward = $Camara/Camara1p.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	var right = $Camara/Camara1p.global_transform.basis.x
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
	move_and_slide()
func _input(event):
	if Input.is_action_just_pressed("1"):
		$Camara/Camara1p/Arma.show()
		$Camara/Camara1p/Arma_aut.hide()
	if Input.is_action_just_pressed("2"):
		$Camara/Camara1p/Arma.hide()
		$Camara/Camara1p/Arma_aut.show()
	if Input.is_action_just_pressed("3"):
		$Camara/Camara1p/Arma.hide()
		$Camara/Camara1p/Arma_aut.hide()
	if Input.is_action_just_pressed("4"):
		$Camara/Camara1p/Arma.hide()
		$Camara/Camara1p/Arma_aut.hide()
