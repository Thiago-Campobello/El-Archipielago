extends Control

@export_file("*.tscn") var escena_intro: String = "res://scenes/IntroNarrativa.tscn"
@export_file("*.tscn") var escena_juego: String = "res://Arch.tscn"

# Paneles
@onready var panel_principal: VBoxContainer = $PanelPrincipal
@onready var panel_submenu_jugar: VBoxContainer = $PanelSubmenuJugar
@onready var panel_opciones: Control = $Opciones

# Botones Menú Principal
@onready var boton_jugar: Button = $PanelPrincipal/BotonJugar
@onready var boton_opciones: Button = $PanelPrincipal/BotonOpciones
@onready var boton_salir: Button = $PanelPrincipal/BotonSalir

# Botones Submenú
@onready var boton_modo_historia: Button = $PanelSubmenuJugar/BotonModoHistoria
@onready var boton_saltar_historia: Button = $PanelSubmenuJugar/BotonSaltarHistoria
@onready var boton_volver: Button = $PanelSubmenuJugar/BotonVolver


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Aseguramos el estado inicial
	panel_principal.visible = true
	panel_submenu_jugar.visible = false
	panel_opciones.visible = false
	
	# Conectamos eventos de clic
	boton_jugar.pressed.connect(_on_jugar_pressed)
	boton_opciones.pressed.connect(_on_opciones_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)
	
	boton_modo_historia.pressed.connect(_on_modo_historia_pressed)
	boton_saltar_historia.pressed.connect(_on_saltar_historia_pressed)
	boton_volver.pressed.connect(_on_volver_pressed)
	

# --- ACCIONES PRINCIPALES ---
func _on_jugar_pressed() -> void:
	panel_principal.visible = false
	panel_submenu_jugar.visible = true

func _on_opciones_pressed() -> void:
	panel_principal.visible = false
	panel_opciones.visible = true

func _on_salir_pressed() -> void:
	get_tree().quit()

# --- ACCIONES SUBMENÚ ---
func _on_modo_historia_pressed() -> void:
	get_tree().change_scene_to_file(escena_intro)

func _on_saltar_historia_pressed() -> void:
	get_tree().change_scene_to_file(escena_juego)

func _on_volver_pressed() -> void:
	panel_submenu_jugar.visible = false
	panel_opciones.visible = false
	panel_principal.visible = true
