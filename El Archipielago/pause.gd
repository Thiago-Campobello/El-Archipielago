extends Node3D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Options.hide()
func _input(event):
	if event.is_action_pressed("pause"):
		pause()
func pause():
	get_tree().paused = not get_tree().paused
	if get_tree().paused: 
		$Options.show()
		$Options/Opciones.hide()
		$Options/VBoxContainer.show()
		get_parent().get_node("HUD").hide()
	else: 
		$Options.hide()
		get_parent().get_node("HUD").show()
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
