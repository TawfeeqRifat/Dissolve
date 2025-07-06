extends AudioStreamPlayer2D

#menu music
var menu_music_position = 0.0

func _ready() -> void:
	SignalBus.play_menu_music.connect(_play_menu_music)
	SignalBus.pause_menu_music.connect(_pause_menu_music)
	
func _play_menu_music():
	print("playing")
	play(menu_music_position)

func _pause_menu_music():
	print("pausing")
	menu_music_position = get_playback_position()
	stop()
