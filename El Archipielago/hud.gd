extends CanvasLayer

signal slot_cambiado(nombre_arma)

var inventario_slots = {
	1: {"nombre": "PUÑOS", "conseguido": false},
	2: {"nombre": "PISTOLA", "conseguido": true},
	3: {"nombre": "SUBFUSIL", "conseguido": true},
	4: {"nombre": "DAGA", "conseguido": false},
	5: {"nombre": "GRANADA", "conseguido": false},
	6: {"nombre": "BOTIQUÍN", "conseguido": false}
}

var slot_seleccionado = 2
@onready var contenedor_slots = $Margen/Container/Filas

func _ready() -> void:
	# Forzamos a que el script siempre procese las teclas
	set_process_input(true)
	
	# Desactivamos el foco de todos los slots para que no se roben el teclado
	for i in range(1, 7):
		var nodo_slot = obtener_nodo_slot(i)
		if nodo_slot and "focus_mode" in nodo_slot:
			nodo_slot.focus_mode = Control.FOCUS_NONE
			
	actualizar_nombres_inventario()
	resaltar_slot_elegido()

func _input(_event: InputEvent) -> void:
	# Detección directa y forzada por mapa de entrada sin importar el foco
	if Input.is_action_just_pressed("1"):
		cambiar_de_slot(1)
	elif Input.is_action_just_pressed("2"):
		cambiar_de_slot(2)
	elif Input.is_action_just_pressed("3"):
		cambiar_de_slot(3)
	elif Input.is_action_just_pressed("4"):
		cambiar_de_slot(4)
	elif Input.is_action_just_pressed("5"):
		cambiar_de_slot(5)
	elif Input.is_action_just_pressed("6"):
		cambiar_de_slot(6)

func cambiar_de_slot(nuevo_slot: int):
	slot_seleccionado = nuevo_slot
	resaltar_slot_elegido()
	
	var datos_item = inventario_slots[slot_seleccionado]
	if datos_item["conseguido"]:
		slot_cambiado.emit(datos_item["nombre"])
	else:
		slot_cambiado.emit("")

func obtener_nodo_slot(indice: int) -> Node:
	match indice:
		1: return contenedor_slots.get_node_or_null("Fila1/Slot1")
		2: return contenedor_slots.get_node_or_null("Fila2/Slot2")
		3: return contenedor_slots.get_node_or_null("Fila2/Slot3")
		4: return contenedor_slots.get_node_or_null("Fila3/Slot4")
		5: return contenedor_slots.get_node_or_null("Fila3/Slot5")
		6: return contenedor_slots.get_node_or_null("Fila3/Slot6")
	return null

func actualizar_nombres_inventario():
	for i in range(7):
		var nodo_slot = obtener_nodo_slot(i)
		if nodo_slot:
			var datos_item = inventario_slots[i]
			var nombre_obj = "Obj" if i == 1 else "Obj" + str(i)
			var label_objeto = nodo_slot.get_node_or_null(nombre_obj)
			
			if label_objeto:
				if datos_item["conseguido"]:
					label_objeto.text = datos_item["nombre"]
					nodo_slot.modulate = Color(1, 1, 1)
				else:
					label_objeto.text = ""
					nodo_slot.modulate = Color(0.4, 0.4, 0.4)

func resaltar_slot_elegido():
	for i in range(1, 7):
		var nodo_slot = obtener_nodo_slot(i)
		var borde = nodo_slot.get_node("BordeSeleccion")
		if i == slot_seleccionado:
			borde.show()
		else:
			borde.hide()

func actualizar_balas(balas, maxx, cargador):
	$Municion/Municion.text = str(balas) + " / " + str(maxx)
	$Municion/Municion/Cargador.text = str(cargador)

func actualizar_vida(vida, vidamax):
	$Vida/Vida.text = str(vida) + " / " + str(vidamax)
