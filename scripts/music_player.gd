extends AudioStreamPlayer2D

@export var VOLUME_UP_SPEED = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_db = -30


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if volume_db < 0:
		volume_db += delta * VOLUME_UP_SPEED
