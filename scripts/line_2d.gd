#class_name Trail
#extends Line2D
#
#
#var MAXPOINTS = 1000
#@onready var curve := Curve2D.new()
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#curve.add_point(get_parent().position)
	#if curve.get_baked_points().size() > MAXPOINTS :
		#print("removing,", curve.get_baked_points().size())
		#curve.remove_point(0)
	#points = curve.get_baked_points()
#
#func stop():
	#print("stoped")
	#set_process(false)
	#await create_tween().tween_property(self,"modulate:a",0,1).finished
	#queue_free()
#
#static func create():
	#var scn = preload("res://Scenes/trail.tscn")
	#return scn.instantiate()
	#
