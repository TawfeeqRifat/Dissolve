extends Node

@onready var pause_screen: CanvasLayer = $PauseScreen
@onready var hud: CanvasLayer = $HUD
@onready var pause_water_splash_timer: Timer = $PauseScreen/pause_screen/pause_water_body/Timer
@onready var level_complete: CanvasLayer = $level_complete
@onready var level: Node2D = $level
@onready var game_over: CanvasLayer = $GameOverScreen

@onready var mesh_movement_timer: Timer = $PauseScreen/pause_screen/mesh_movement_timer

@onready var pause: Node2D = $PauseScreen/pause_screen


var level_no: int

func _ready() -> void:
	SignalBus.level_complete.connect(_on_level_complete)
	SignalBus.actual_game_over.connect(_on_actual_game_over)
	level_no = int(name.split('_')[1])
	
func _on_actual_game_over():
	level.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	hud.visible = false
	game_over.visible = true
	#game_over.water_body.spalsh_once()
	
func _on_level_complete():
	level_complete.visible = true
	hud.visible = false
	
	if Global.unlocked_levels == level_no:
		Global.unlocked_levels = level_no + 1

#pause screen trigger
func _on_button_pressed() -> void:
	level.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	hud.visible = false
	pause_screen.visible = true
	pause.splash_once()
	mesh_movement_timer.start()
	pause.movement()


func _on_continue_pressed() -> void:
	level.process_mode = ProcessMode.PROCESS_MODE_INHERIT
	hud.visible = true
	pause_screen.visible = false
	mesh_movement_timer.stop()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
		get_tree().change_scene_to_file(Global.MAIN_MENU)


func _on_next_level_pressed() -> void:
	print("next_leveled")
	get_tree().change_scene_to_file("res://Scenes/levels/level_"+str(level_no+1)+".tscn")


func _on_replay_pressed() -> void:
	get_tree().reload_current_scene()


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file(Global.LEVEL_SELECTION_MENU)
