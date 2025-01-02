extends Camera2D

@export var SPEED: float

func _process(delta: float) -> void:
	position.x = SPEED * delta + position.x
