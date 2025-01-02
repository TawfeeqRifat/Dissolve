extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var mesh: MeshInstance2D = $mesh
var last = 1

var rng = RandomNumberGenerator.new()
func movement():
	print("move")
	var val = rng.randf_range(0,100)
	create_tween().tween_property(mesh,"position",Vector2(mesh.position.x + val * - last, mesh.position.y+10),5)
	val = rng.randf_range(15, 45)
	create_tween().tween_property(mesh,"rotation_degrees",val * last,rng.randf_range(5,10))
	last =- last

func _on_mesh_movement_timer_timeout() -> void:
	movement()
	
@onready var pause_water_body: Node2D = $pause_water_body

func splash_once():
	pause_water_body.splash_once()
