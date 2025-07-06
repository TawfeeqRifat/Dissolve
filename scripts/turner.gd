extends Node2D



func _on_area_2d_area_exited(area: Area2D) -> void:
	SignalBus.turner.emit()
