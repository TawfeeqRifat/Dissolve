extends Node2D

func _ready() -> void:
	SignalBus.game_over.connect(_on_player_game_over)


func _on_player_game_over() -> void:
	pass
	#get_tree().reload_current_scene()
