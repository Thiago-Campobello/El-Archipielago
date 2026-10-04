extends Control

@export_file("*.tscn") var escena_juego: String = "res://Arch.tscn"

# Arrastrá tus 8 imágenes en el Inspector en este Array
@export var imagenes_historia: Array[Texture2D] = []

# Los 8 textos de la historia
var textos_historia: Array[String] = [
	"Hace décadas, el archipiélago fue una zona de investigación. Bajo las islas yacía una red de energía muy antigua...",
	"Para conectar las islas y el exterior, la comunidad científica construyó un sistema de 7 torres de comunicación...",
	"Al operar las torres, los investigadores interactuaron por accidente con la Red Antigua, despertando algo dormido...",
	"De un momento a otro ocurrió el apagón. Todas las comunicaciones con el exterior se cortaron de forma deliberada...",
	"Los habitantes quedaron aislados. Un grupo, los aislacionistas, decidió proteger la Red Antigua del mundo exterior...",
	"La activación de la red alteró el entorno, la fauna local mutó y aparecieron amenazas desconocidas...",
	"Tras semanas de silencio absoluto, has sido enviado al archipiélago en una misión de investigación...",
	"Tu objetivo: reactivar las 7 torres y restablecer el contacto... pero la verdad oculta lo cambiará todo."
]

var indice_actual: int = 0

@onready var imagen_display: TextureRect = $TextureRect
@onready var texto_display: Label = $Panel/TituloHistoria
@onready var boton_siguiente: Button = $BotonSiguiente
@onready var boton_saltar: Button = $BotonSaltar

func _ready() -> void:
	boton_siguiente.pressed.connect(_on_siguiente_pressed)
	boton_saltar.pressed.connect(_on_saltar_pressed)
	mostrar_diapositiva(0)

func mostrar_diapositiva(i: int) -> void:
	# Carga la imagen de forma segura si existe en la lista
	if i < imagenes_historia.size() and imagenes_historia[i] != null:
		imagen_display.texture = imagenes_historia[i]
	
	# Carga el texto
	if i < textos_historia.size():
		texto_display.text = textos_historia[i]
	
	# Cambia el texto del botón al llegar al final
	if i == textos_historia.size() - 1:
		boton_siguiente.text = "COMENZAR JUEGO"
		boton_siguiente.position=Vector2(1010,572)
	else:
		boton_siguiente.text = "SIGUIENTE"

func _on_siguiente_pressed() -> void:
	indice_actual += 1
	if indice_actual >= textos_historia.size():
		_on_saltar_pressed()
	else:
		mostrar_diapositiva(indice_actual)

func _on_saltar_pressed() -> void:
	get_tree().change_scene_to_file(escena_juego)
