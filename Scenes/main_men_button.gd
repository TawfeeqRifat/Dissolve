extends Button

func _on_mouse_entered() -> void:
	create_tween().tween_property(self,"scale",Vector2(1.5,1.5),0.1)
	create_tween().tween_property(self,"rotation_degrees",-27.5,0.1)
	SignalBus.play_select_sfx.emit()

func _on_mouse_exited() -> void:
	create_tween().tween_property(self,"scale",Vector2(1,1),0.1)
	create_tween().tween_property(self,"rotation_degrees",0,0.1)


func _on_pressed() -> void:
	SignalBus.play_press_sfx.emit()
