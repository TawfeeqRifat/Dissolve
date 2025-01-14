extends Node2D



@export var SPEED: float = 320 #250 improved speed for this new game
@export var SCALE_SPEED: float = 0.05
@export var camera_2d: Camera2D
#@onready var player: RigidBody2D =  $"../Player"
@onready var player: RigidBody2D 

var chances = 3
var scale_value: float = 1
func _ready() -> void:

	player = Global.PLAYER.instantiate()
	#player.position = Vector2(camera_2d.position.x-275,-45)
	player.position = checkpoint
	add_child(player)
	print("player added to the oohohoh")
	if upsidedown == true: 
		print("calling this upside")
		player.startAfterCheckPoint()
	else:
		print("not calling upsidedown")
	camera_2d.SPEED = SPEED
	player.SPEED = SPEED
	player.SCALE_SPEED = SCALE_SPEED
	player.scale_value = scale_value
	
	SignalBus.game_over.connect(_on_player_game_over)
	SignalBus.refilling_start.connect(_on_refill_zone_refilling_start)
	SignalBus.refilling_stop.connect(_on_refill_zone_refilling_stop)
	SignalBus.level_complete.connect(_on_level_complete)
	SignalBus.checkpoint.connect(_on_checkpointed)

#checkpoint functionality------------------------------------------------------

var checkpoint = Vector2(-275,-45)
var upsidedown = false  #is the checkpoint upside down or not

func _on_checkpointed(pos,up):
	checkpoint = pos
	if up:
		print("upside")
		upsidedown = true
		print(upsidedown)
	else:
		print("downside")
		upsidedown = false

#--------------------------------------------------------------------------------
#gamer over functionality-------------------------------------------------------

#to allow to make the player aware of the failure
@onready var restart_timer: Timer = $restart_timer

func _on_player_game_over() -> void:
	print("Game Over")
	chances -= 1 
	if chances <= 0:
		SignalBus.actual_game_over.emit()
	player.SPEED = 0
	camera_2d.SPEED = 50
	player.queue_free()
	restart_timer.start()

func _on_restart_timer_timeout() -> void:
	await create_tween().tween_property(camera_2d, "position", Vector2(checkpoint.x + 275,0),1 ).finished
	_ready()

#-------------------------------------------------------------------------------

#refill functionality ----------------------------------------------------------

@onready var refill_timer: Timer = $refill_timer

func _on_refill_zone_refilling_start() -> void:
	refill_timer.start(1)
	player.refill()

func _on_refill_zone_refilling_stop() -> void:
	refill_timer.stop()
	player.cancel_refill()
#
func _on_refill_timer_timeout() -> void:
	player.refilling()

#-------------------------------------------------------------------------------

#level complete-----------------------------------------------------------------


func _on_level_complete():
	print("Manager: levelComplete")
	camera_2d.SPEED = 0
	#player.camera_2d.enabled = true
	camera_2d.enabled = false
	
#-------------------------------------------------------------------------------

var cur_state= "None" #None, inverting, rotating

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate_camera") and cur_state == "None":
		cur_state = "rotating"
		rotate_camera()
	if event.is_action_pressed("invert_camera") and cur_state == "None":
		cur_state = "inverting"
		invertCamera()

func invertCamera():
	await create_tween().tween_property(camera_2d,"zoom",Vector2(camera_2d.zoom.x,-camera_2d.zoom.y),0.3).finished
	cur_state = "None"
	
func rotate_camera():
	create_tween().tween_property(camera_2d, "zoom", Vector2(1,1) ,0.5)
	await create_tween().tween_property(camera_2d, "rotation_degrees", camera_2d.rotation_degrees+180 ,1).finished
	create_tween().tween_property(camera_2d, "zoom", Vector2(1.5,1.5) ,0.5)
	cur_state = "None"
