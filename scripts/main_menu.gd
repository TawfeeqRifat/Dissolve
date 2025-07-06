extends Control

@onready var main_camera: Camera3D = $Node3D/MainCamera
@onready var options_camera: Camera3D = $OptionsCamera
@onready var main_menu: CanvasLayer = $Node3D/MainMenu

func _ready() -> void:
	Global.load_save()
	
	#music
	SignalBus.play_menu_music.emit()

func _on_play_pressed() -> void:
	
	#music
	SignalBus.pause_menu_music.emit()
	
	get_tree().change_scene_to_file(Global.LEVEL_SELECTION_MENU)


func _on_options_pressed() -> void:
	main_menu.visible = false
	await create_tween().tween_property(main_camera, "position",Vector3(0.656,1.424,0.015),1)
	await create_tween().tween_property(main_camera,"global_rotation_degrees",Vector3(-90,90,0),1)

func _on_quit_pressed() -> void:
	get_tree().quit()

#@onready var player: CSGBox3D = $Node3D/CharacterBody3D/player
@onready var character: CharacterBody3D = $Node3D/character
@onready var player: CSGBox3D = $Node3D/player2

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			await create_tween().tween_property(player,"global_position",Vector3(0.6,1,0),0.4)
			await get_tree().create_timer(0.5).timeout
			await create_tween().tween_property(player,"global_position",Vector3(0.6,0.2,0),0.4)
