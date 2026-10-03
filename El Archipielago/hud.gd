extends CanvasLayer
@onready var slots=get_parent().get_node_or_null("Player").get_node_or_null("Camara").get_node_or_null("Camara1p")
@onready var s1=slots.get_node_or_null("Slot1")
@onready var s2=slots.get_node_or_null("Slot2")
@onready var s3=slots.get_node_or_null("Slot3")
@onready var s4=slots.get_node_or_null("Slot4")
@onready var s5=slots.get_node_or_null("Slot5")
@onready var s6=slots.get_node_or_null("Slot6")
@onready var bloom=get_node_or_null("Bloom")
var cambio=false
@onready var inventario_slots = [s1,s2,s3,s4,s5,s6]
var conseguidos=[true,true,true,false,true,false]
var nombres=["PUÑOS","PISTOLA","SUBFUSIL","DAGA","GRANADA","BOTIQUIN"]
var slot_seleccionado = 1
var str1
var str2
@onready var contenedor_slots = $Margen/Container/Filas
func _ready() -> void:
	for i in range(1, 7):
		var nodo_slot = obtener_nodo_slot(i)
		if nodo_slot and "focus_mode" in nodo_slot:
			nodo_slot.focus_mode = Control.FOCUS_NONE
	cambiar_de_slot(slot_seleccionado)
	actualizar_nombres_inventario()
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("apuntar") and conseguidos[slot_seleccionado]:
		$Bloom.texture=preload("res://IMGS/Bloom/02_moving_in.png")
		await get_tree().create_timer(0.05).timeout
		$Bloom.texture=preload("res://IMGS/Bloom/03_closer.png")
		await get_tree().create_timer(0.05).timeout
		$Bloom.texture=preload("res://IMGS/Bloom/04_nearly_aimed.png")
		await get_tree().create_timer(0.05).timeout
		$Bloom.texture=preload("res://IMGS/Bloom/05_ads.png")
	if Input.is_action_just_released("apuntar") and conseguidos[slot_seleccionado]:
		$Bloom.texture=preload("res://IMGS/Bloom/04_nearly_aimed.png")
		await get_tree().create_timer(0.05).timeout
		$Bloom.texture=preload("res://IMGS/Bloom/03_closer.png")
		await get_tree().create_timer(0.05).timeout
		$Bloom.texture=preload("res://IMGS/Bloom/02_moving_in.png")
		await get_tree().create_timer(0.05).timeout
		$Bloom.texture=preload("res://IMGS/Bloom/01_hipfire.png")
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"):
		cambiar_de_slot(0)
	elif Input.is_action_just_pressed("2"):
		cambiar_de_slot(1)
	elif Input.is_action_just_pressed("3"):
		cambiar_de_slot(2)
	elif Input.is_action_just_pressed("4"):
		cambiar_de_slot(3)
	elif Input.is_action_just_pressed("5"):
		cambiar_de_slot(4)
	elif Input.is_action_just_pressed("6"):
		cambiar_de_slot(5)

func cambiar_de_slot(nuevo_slot: int):
	slot_seleccionado = nuevo_slot
	if slot_seleccionado==0 || slot_seleccionado>=3:
		bloom.hide()
	else:
		bloom.show()
	resaltar_slot_elegido()
	usar_slot(nuevo_slot)
	inv()
func inv():
	if conseguidos[slot_seleccionado] and slot_seleccionado>0 and slot_seleccionado<5 and slot_seleccionado!=3:
		$Municion.show()
		if slot_seleccionado==1 or slot_seleccionado==2:
			var arma=inventario_slots[slot_seleccionado].get_node("Arma")
			str1=arma.str1
			str2=arma.str2
			actualizar_balas(str1,str2)
		else:
			var granada=inventario_slots[4].get_node("Granada")
			str1=str(granada.cantgr)
			str2=""
			actualizar_balas(str1,str2)
	else:
		$Municion.hide()

func usar_slot(slot):
	for i in range(6):
		if i==slot:
			inventario_slots[i].show()
		else:
			inventario_slots[i].hide()
func obtener_nodo_slot(indice: int) -> Node:
	match indice:
		0: return contenedor_slots.get_node_or_null("Fila1/Slot1")
		1: return contenedor_slots.get_node_or_null("Fila2/Slot2")
		2: return contenedor_slots.get_node_or_null("Fila2/Slot3")
		3: return contenedor_slots.get_node_or_null("Fila3/Slot4")
		4: return contenedor_slots.get_node_or_null("Fila3/Slot5")
		5: return contenedor_slots.get_node_or_null("Fila3/Slot6")
	return null
func actualizar_nombres_inventario():
	for i in range(6):
		var nodo_slot = obtener_nodo_slot(i)
		if nodo_slot:
			var nombre_obj = "Obj" if i == 0 else "Obj" + str(i+1)
			var label_objeto = nodo_slot.get_node_or_null(nombre_obj)
			if label_objeto:
				if conseguidos[i]:
					label_objeto.text = nombres[i]
					nodo_slot.modulate = Color(1, 1, 1)
				else:
					label_objeto.text = ""
					nodo_slot.modulate = Color(0.4, 0.4, 0.4)

func resaltar_slot_elegido():
	for i in range(6):
		var nodo_slot = obtener_nodo_slot(i)
		var borde = nodo_slot.get_node("BordeSeleccion")
		if i == slot_seleccionado:
			borde.show()
			if !conseguidos[i]:
				bloom.hide()
		else:
			borde.hide()

func actualizar_balas(string1, string2):
	$Municion/Municion.text = string1
	$Municion/Municion/Cargador.text = string2

func actualizar_vida(vida, vidamax):
	$Vida/Vida.text = str(vida) + " / " + str(vidamax)

func quitar_arma_inventario(nombre_arma: String):
	for i in range(6):
		if nombres[i] == nombre_arma:
			conseguidos[i] = false
			actualizar_nombres_inventario()
			resaltar_slot_elegido()
			break
	inv()

func agregar_arma_inventario(nombre_arma: String):
	for i in range(6):
		if nombres[i] == nombre_arma:
			conseguidos[i] = true
			actualizar_nombres_inventario()
			break
	inv()

func mostrar_mensaje_interactuar(texto: String):
	$CartelInteractuar.text = texto
	$CartelInteractuar.visible = true
func _p1():
	get_node("Bloom").show()
func _p3():
	get_node("Bloom").hide()
func ocultar_mensaje_interactuar():
	$CartelInteractuar.visible = false
