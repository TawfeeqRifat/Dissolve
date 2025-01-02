extends Area2D



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(position)
		SignalBus.checkpoint.emit(position)
