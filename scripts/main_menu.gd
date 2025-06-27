extends Control

func _ready() -> void:
	Global.load_save()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(Global.LEVEL_SELECTION_MENU)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
