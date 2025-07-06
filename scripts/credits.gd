extends Node2D

var speed = 100
@export var end_y_pos = -200
@onready var credits_box: Node2D = $CanvasLayer/credits_box

func _ready():
	SignalBus.play_menu_music.emit()
	

func _process(delta: float) -> void:
	credits_box.position.y -= speed * delta
	if credits_box.position.y < end_y_pos:
		SignalBus.pause_menu_music.emit()
		get_tree().change_scene_to_file(Global.MAIN_MENU)
