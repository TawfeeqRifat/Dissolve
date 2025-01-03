extends CanvasLayer
@onready var levels: Control = $levels

var rng = RandomNumberGenerator.new()
func _ready() -> void:
	for i in levels.get_children():
		Global.all_levels.append(i.text)
		i.rotation_degrees = rng.randf_range(-15,15) 
		i.connect('pressed',open_level.bind(i.text))
		if int(i.text) <= Global.unlocked_levels:
			pass
		else:
			i.disabled = true
	print(Global.all_levels)

func open_level(level_no):
	#get_tree().change_scene_to_file("res://Scenes/levels/level_"+level_no+".tscn")
	var level = load("res://Scenes/levels/level_"+level_no+".tscn")
	get_tree().change_scene_to_packed(level)
	
