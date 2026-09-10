extends Control


func _on_play_pressed() -> void:
	get_parent().pause()
func _on_exit_pressed() -> void:
	get_tree().quit()
