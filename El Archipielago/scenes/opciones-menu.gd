extends Control
var boton_cambiando
var control_cambiando
var esperando_tecla=false
var controles=["move_forward","move_left","move_backward","move_right","jump","run","apuntar","shoot","reload","alt_camara","desbq_mouse","1","2","3","4","5","6"]
func _on_salir_pressed() -> void:
	get_parent().get_node("PanelPrincipal").show()
	hide()
func cambiar_tecla(tecla):
	control_cambiando=controles[tecla]
	esperando_tecla=true
	InputMap.action_erase_events(control_cambiando)
	var f=0
	for fila in $ScrollContainer/Container.get_children():
		if fila is HBoxContainer:for boton in fila.get_children():
			if boton is Button:
				if f==tecla:
					boton_cambiando=boton
					boton.text="Presione tecla"
		if fila is HBoxContainer: f+=1
func _ready() -> void:
	var f=0
	for fila in $ScrollContainer/Container.get_children():
		if fila is HBoxContainer:for boton in fila.get_children():
			if boton is Button:
				var evento=InputMap.action_get_events(controles[f])[0]
				boton.text=nombre_evento(evento)
		if fila is HBoxContainer: f+=1
func _input(event):
	if not esperando_tecla:
		return
	if nombre_evento(event)!="???":
		InputMap.action_add_event(control_cambiando, event)
		boton_cambiando.text=nombre_evento(event)
		control_cambiando=null
		boton_cambiando=null
		esperando_tecla=false
func nombre_evento(evento):
	if evento is InputEventKey:
		var codigo = evento.physical_keycode
		match codigo:
			KEY_SPACE:
				return "SPACE"
			KEY_SHIFT:
				return "SHIFT"
			KEY_CTRL:
				return "CTRL"
			KEY_ALT:
				return "ALT"
			KEY_ESCAPE:
				return "ESC"
			KEY_ENTER:
				return "ENTER"
			KEY_TAB:
				return "TAB"
			KEY_BACKSPACE:
				return "BACKSPACE"
			KEY_F1:
				return "F1"
			KEY_F2:
				return "F2"
			KEY_F3:
				return "F3"
			KEY_F4:
				return "F4"
			KEY_F5:
				return "F5"
			KEY_F6:
				return "F6"
			KEY_F7:
				return "F7"
			KEY_F8:
				return "F8"
			KEY_F9:
				return "F9"
			KEY_F10:
				return "F10"
			KEY_F11:
				return "F11"
			KEY_F12:
				return "F12"
		return OS.get_keycode_string(codigo)
	elif evento is InputEventMouseButton:
		match evento.button_index:
			MOUSE_BUTTON_LEFT:
				return "LMB"
			MOUSE_BUTTON_RIGHT:
				return "RMB"
			MOUSE_BUTTON_MIDDLE:
				return "MMB"
	return "???"


func _on_slot_4_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(14)
func _on_slot_3_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(13)
func _on_slot_2_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(12)
func _on_slot_1_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(11)
func _on_desblqm_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(10)
func _on_alt_camara_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(9)
func _on_recargar_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(8)
func _on_disparar_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(7)
func _on_atras_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(2)
func _on_adelante_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(0)
func _on_derecha_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(3)
func _on_izquierda_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(1)
func _on_saltar_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(4)
func _on_apuntar_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(6)
func _on_slot_5_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(15)
func _on_slot_6_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(16)
func _on_correr_pressed() -> void:
	if not esperando_tecla:cambiar_tecla(5)
