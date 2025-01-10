extends Node2D

@export var k = 0.015 #spring factor 0.015
@export var d = 0.03 #dampening factor 0.03
@export var spread = 0.0005 #spread value - how much the waves will spread to their neighbours 0.0002
@export var color: Color
var springs = [] #to create and hold the springs
var passes = 8 #how much the process repeated every frame
@export var max_wave_height = 0.5
@export var dist_bw_springs = 32
@export  var spring_number = 10

@onready var waterBorder = $water_border
@export var border_thickness = 1.1

@export var depth = 0 #depth of the water
var target_height = global_position.y
@onready var bottom = target_height + depth

@onready var water_polygon: Polygon2D = $water_polygon

@onready var water_spring = preload("res://Scenes/water_spring.tscn")

func _ready() -> void:
	#waterBorder.spline_length = border_thickness
	for i in range(spring_number):
		var x_pos = dist_bw_springs * i
		var w = water_spring.instantiate()
		add_child(w)
		springs.append(w)
		if i==0 or i==spring_number-1:
			w.initialize(x_pos,-7 )
		else: w.initialize(x_pos)
	splash_once()
	
var rng = RandomNumberGenerator.new()

func splash_once():
	print("splashing once")
	splash(1,2)
	splash(rng.randf_range((spring_number/4),spring_number/2),2)
	splash(rng.randf_range(spring_number/2,spring_number),2)

func _physics_process(delta: float) -> void:
	
	for i in springs:
		i.water_update(k,d)
	
	var left_deltas=[]
	var right_deltas=[]
	
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	for j in range(passes):
		for i in range(springs.size()):
			
			if i < springs.size()-1:
				right_deltas[i] = min(spread * (springs[i].height - springs[i+1].height),max_wave_height)
				springs[i+1].velocity += right_deltas[i]
			else:
				right_deltas[i] = min(spread * (springs[i].height - springs[0].height),max_wave_height)
				springs[0].velocity += right_deltas[i]
	new_border()
	draw_water_body()

func draw_water_body():
	
	var curve =  waterBorder.curve
	var points = Array(curve.get_baked_points())
	
	#var surface_points = []
	#for i in range(springs.size()):
		#surface_points.append(springs[i].position)
	var water_polygon_points = points
	
	var first_index = 0
	var last_index = water_polygon_points.size()-1
	
	
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x,bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x,bottom))
	water_polygon_points = PackedVector2Array(water_polygon_points)
	water_polygon.set_polygon(water_polygon_points)
	if color: water_polygon.set_color(color)

func splash(index, speed):
	if index >=0 and index< springs.size():
		springs[index].velocity += speed

func new_border():
	var curve = Curve2D.new().duplicate()
	var surface_points = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
		
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
		
	waterBorder.curve = curve 
	waterBorder.smooth(true)
	waterBorder.queue_redraw()
	
