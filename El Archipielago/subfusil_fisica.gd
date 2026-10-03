extends RigidBody3D

@export var nombre_objeto: String = "Subfusil"

func interactuar(player):
	var arma_mano = player.get_node_or_null("Camara/Camara1p/Slot3/Arma")
	if arma_mano:
		arma_mano.visible = true
		if player.hud:
			player.hud.conseguidos[2] = true
			player.hud.actualizar_nombres_inventario()
			player.hud.cambiar_de_slot(2)
	queue_free()
func configurar_desde_arma(arma: Node3D) -> void:
	for hijo in arma.get_children():
		if hijo is MultiMeshInstance3D:
			add_child(hijo.duplicate())
		elif hijo is CollisionShape3D:
			add_child(hijo.duplicate())
