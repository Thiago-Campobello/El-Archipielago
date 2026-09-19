extends Control


func _on_play_pressed() -> void:
	get_parent().pause()
func _on_exit_pressed() -> void:
	get_tree().quit()
func _on_options_pressed() -> void:
	$Opciones.show()
	$VBoxContainer.hide()


func _on_salir_pressed() -> void:
	pass # Replace with function body.


func _on_apuntar_pressed() -> void:
	pass # Replace with function body.


func _on_saltar_pressed() -> void:
	pass # Replace with function body.


func _on_derecha_pressed() -> void:
	pass # Replace with function body.


func _on_izquierda_pressed() -> void:
	pass # Replace with function body.


func _on_atras_pressed() -> void:
	pass # Replace with function body.
