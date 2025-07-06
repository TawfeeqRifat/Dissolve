extends Node

const LEVEL_SELECTION_MENU = "res://Scenes/level_select_menu.tscn"
const MAIN_MENU = "res://Scenes/main_menu.tscn"
const PLAYER = preload("res://Scenes/player_revised.tscn")
const LEVEL_SELECT_BUTTON = "res://Scenes/level_select_button.tscn"
const CREDITS = "res://Scenes/credits.tscn"
var all_levels = []
var total_levels = 4

#save data variables
var unlocked_levels
var levels_status



func save_game(level,stars):
	var save_file = FileAccess.open("user://savegame.save",FileAccess.WRITE)
	if not levels_status.has(level):
		levels_status[level] = stars
		print(level,unlocked_levels)
		if unlocked_levels == level:
			print("level unlocked")
			unlocked_levels = level	+ 1
		print("shoulh have unlocked")
	else:
		if levels_status[level] < stars:
			levels_status[level] = stars	
	print("Game Saved!")
	save_file.store_line(JSON.stringify(levels_status))
	save_file.store_line(str(unlocked_levels))

	
func load_save():
	if not FileAccess.file_exists("user://savegame.save"):	
		unlocked_levels = 1
		levels_status = {}
		print("loaded new save")
		return 
	var save_file = FileAccess.open("user://savegame.save",FileAccess.READ)
	print("loading the old save")
	var json = JSON.new()
	levels_status = json.parse_string(save_file.get_line())
	unlocked_levels = int(save_file.get_line())
	
	
