extends CanvasLayer
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass
func actualizar_balas(balas,max,cargador):
	$Municion/Municion.text= str(balas)+" / "+str(max)
	$Municion/Municion/Cargador.text= str(cargador)
func actualizar_vida(vida,vidamax):
	$Vida/Vida.text= str(vida)+" / "+str(vidamax)
