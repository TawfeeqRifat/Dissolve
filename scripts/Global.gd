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

#music seeting
var MUSIC_VOLUME
var SFX_VOLUME


func save_game(level,stars):
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
	print("Changes updated")
	save()
	

func save():
	var save_file = FileAccess.open("user://savegame.save",FileAccess.WRITE)
	save_file.store_line(JSON.stringify(levels_status))
	save_file.store_line(str(unlocked_levels))
	save_file.store_line(str(MUSIC_VOLUME))
	save_file.store_line(str(SFX_VOLUME))
	print("saved")
	
func load_save():
	if not FileAccess.file_exists("user://savegame.save"):	
		unlocked_levels = 1
		levels_status = {}
		MUSIC_VOLUME = 0
		SFX_VOLUME = 0
		print("loaded new save")
		return 
	var save_file = FileAccess.open("user://savegame.save",FileAccess.READ)
	print("loading the old save")
	var json = JSON.new()
	levels_status = json.parse_string(save_file.get_line())
	unlocked_levels = int(save_file.get_line())
	MUSIC_VOLUME = int(save_file.get_line())
	SFX_VOLUME = int(save_file.get_line())
	
	
