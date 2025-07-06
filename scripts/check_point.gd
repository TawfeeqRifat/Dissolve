extends Area2D

@onready var position_node: Node2D = $position
@export var upsidedown: bool = false
@onready var color: Node2D = $color

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		color.visible = false
		SignalBus.checkpoint.emit(position_node.global_position,upsidedown)
