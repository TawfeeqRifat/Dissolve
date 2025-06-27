extends CanvasLayer
@onready var levels: Control = $levels

var button = preload(Global.LEVEL_SELECT_BUTTON)
var upper_axis = 205
var lower_axis = 405
var rng = RandomNumberGenerator.new()

var unlocked_levels = []
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
			unlocked_levels.append(lev)
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



@onready var level_button_movement_timer: Timer = $level_button_movement_timer
var last = 1
func level_button_movement():
	var val
	for i in unlocked_levels:
		if rng.randf_range(-1,1) > 0: 
			val = rng.randf_range(0,20)
			create_tween().tween_property(i,"position",Vector2(i.position.x + val * - last, i.position.y),level_button_movement_timer.wait_time)
		#val = rng.randf_range(5,10)
		#create_tween().tween_property(i,"rotation_degrees",val * last,rng.randf_range(5,10))
	last =- last
	level_button_movement_timer.wait_time = rng.randi_range(2,6)


func _on_level_button_movement_timer_timeout() -> void:
	level_button_movement()
