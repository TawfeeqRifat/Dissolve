extends Control

@onready var main_camera: Camera3D = $Node3D/MainCamera
@onready var options_camera: Camera3D = $OptionsCamera
@onready var main_menu: CanvasLayer = $MainMenu
@onready var options: CanvasLayer = $Options

@onready var music_slider: HSlider = $Options/music_slider
@onready var sfx_slider: HSlider = $Options/sfx_slider

#to avoid player jumping during options
var options_selected = false

func _ready() -> void:
	Global.load_save()
	
	#music
	SignalBus.play_menu_music.emit()
	
	#music options
	music_slider.value = Global.MUSIC_VOLUME
	sfx_slider.value = Global.SFX_VOLUME

func _on_play_pressed() -> void:
	
	#music
	SignalBus.pause_menu_music.emit()
	
	get_tree().change_scene_to_file(Global.LEVEL_SELECTION_MENU)


func _on_options_pressed() -> void:
	main_menu.visible = false
	await create_tween().tween_property(main_camera, "position",Vector3(0.656,1.424,0.015),1)
	await create_tween().tween_property(main_camera,"global_rotation_degrees",Vector3(-90,90,0),1)
	await get_tree().create_timer(1).timeout
	options.visible = true
	options_selected = true
	
func _on_quit_pressed() -> void:
	Global.save()
	get_tree().quit()

#@onready var player: CSGBox3D = $Node3D/CharacterBody3D/player
@onready var character: CharacterBody3D = $Node3D/character
@onready var player: CSGBox3D = $Node3D/player2

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and not options_selected:
			await create_tween().tween_property(player,"global_position",Vector3(0.654,1,0),0.4)
			await get_tree().create_timer(0.5).timeout
			await create_tween().tween_property(player,"global_position",Vector3(0.654,0.2,0),0.4)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),value)
	Global.MUSIC_VOLUME = value

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),value)
	Global.SFX_VOLUME = value


func _on_back_pressed() -> void:
	options.visible = false
	await create_tween().tween_property(main_camera, "position",Vector3(3.33,2.082,1.62),1)
	await create_tween().tween_property(main_camera,"global_rotation_degrees",Vector3(-46.1,89.8,0.1),1)
	await get_tree().create_timer(1).timeout
	main_menu.visible = true
	options_selected = false
