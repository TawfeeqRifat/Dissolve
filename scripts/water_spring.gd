extends Node2D

var velocity = 0
var force = 0
var height = position.y
var target_height = position.y + 80
	
func water_update(spring_constant,dampening):
	
	height = position.y
	var x = height - target_height 
	var loss = - dampening * velocity 
	force = - spring_constant * x + loss
	velocity += force
	position.y += velocity
	pass

func initialize(x_position,y=null):
	if y:
		height = position.y - y
		target_height = position.y - y
	else: 
		height = position.y 
		target_height = position.y
	position.x = x_position
	velocity = 0