extends Node3D
func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused=not get_tree().paused
		Input.mouse_mode= Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED
