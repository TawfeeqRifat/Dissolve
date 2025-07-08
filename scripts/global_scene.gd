extends Node2D

@onready var press_sfx: AudioStreamPlayer2D = $press_sfx
@onready var select_sfx: AudioStreamPlayer2D = $select_sfx

func _ready() -> void:
	SignalBus.play_press_sfx.connect(_play_press_sfx)
	SignalBus.play_select_sfx.connect(_play_select_sfx)

func _play_press_sfx():
	press_sfx.play()
	
func _play_select_sfx():
	select_sfx.play()
