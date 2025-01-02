extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


func _ready():
	pass
#player entered refill zone
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.refilling_start.emit()
		

#player left refill zone
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.refilling_stop.emit()
