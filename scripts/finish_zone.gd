extends Node2D



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.level_complete.emit()
		print("level complete")
