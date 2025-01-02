extends Node2D

@export var k = 0.015 #spring factor 0.015
@export var d = 0.03 #dampening factor 0.03
@export var spread = 0.0005 #spread value - how much the waves will spread to their neighbours 0.0002
@export var color = Color.WHITE
var springs = [] #to create and hold the springs
var passes = 8 #how much the process repeated every frame

@export var dist_bw_springs = 32
@export  var spring_number = 6

@export var depth = 490 #depth of the water
var target_height = global_position.y
var bottom = target_height + depth

@onready var water_polygon: Polygon2D = $water_polygon

@onready var water_spring = preload("res://Scenes/water_spring.tscn")

func _ready() -> void:
	for i in range(spring_number):
		var x_pos = dist_bw_springs * i
		var w = water_spring.instantiate()
		add_child(w)
		springs.append(w)
		w.initialize(x_pos)
	splash(1,1)

func _physics_process(delta: float) -> void:
	
	for i in springs:
		i.water_update(k,d)
	
	var left_deltas=[]
	var right_deltas=[]
	
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
		pass
	for j in range(passes):
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i <springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	draw_water_body()

func draw_water_body():
	var surface_points = [] #holds the positions of our surfaces
	for i in range(springs.size()):
		surface_points.append((springs[i].position))
	
	var first_index = 0
	var last_index = surface_points.size()-1
	
	var water_polygon_points = surface_points
	water_polygon_points.append(Vector2(surface_points[last_index].x,bottom))
	water_polygon_points.append(Vector2(surface_points[first_index].x,bottom))
	water_polygon_points = PackedVector2Array(water_polygon_points)
	
	water_polygon.set_polygon(water_polygon_points)
	water_polygon.set_color(color)


func splash(index, speed):
	if index >=0 and index< springs.size():
		springs[index].velocity += speed


func _on_timer_timeout() -> void:
	splash(1,1)
