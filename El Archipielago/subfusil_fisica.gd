extends RigidBody3D

@export var nombre_objeto: String = "Subfusil"

func interactuar(player):
	var arma_mano = player.get_node_or_null("Camara/Camara1p/Slot3/Arma_aut")
	if arma_mano:
		arma_mano.visible = true
		if player.hud:
			player.hud.inventario_slots[3]["conseguido"] = true
			player.hud.actualizar_nombres_inventario()
			player.hud.actualizar_balas(arma_mano.balas, arma_mano.balasmax, arma_mano.cargador)
	queue_free()
