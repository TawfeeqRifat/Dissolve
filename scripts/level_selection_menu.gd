extends CanvasLayer
@onready var levels: Control = $levels

var button = preload(Global.LEVEL_SELECT_BUTTON)
var upper_axis = 205
var lower_axis = 405
var rng = RandomNumberGenerator.new()
func _ready() -> void:
	var cur_x = 120
	for i in range(Global.total_levels):
		Global.all_levels.append(i)
		var lev = button.instantiate()
		lev.buttonName = str(i)
		add_child(lev)
		if i <= Global.unlocked_levels:
			lev.rotation_degrees = rng.randf_range(-7,7) 
			if i%2:
				lev.position = Vector2(cur_x,lower_axis)
			else:
				lev.position = Vector2(cur_x,upper_axis)
		else:
			lev.rotation_degrees = 45
			lev.button.disabled = true
			if i%2:
				lev.position = Vector2(cur_x,lower_axis+50)
			else:
				lev.position = Vector2(cur_x,upper_axis-45)
		cur_x += 300
		lev.button.connect('pressed',open_level.bind(i))


func open_level(level_no):
	var level = load("res://Scenes/levels/level_"+str(level_no)+".tscn")
	get_tree().change_scene_to_packed(level)
	
