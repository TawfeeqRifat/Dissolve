extends RigidBody2D

@export var SPEED: float
@export var SCALE_SPEED: float
@export var JUMP_FORCE = 400

var jump_gravity = 1
var fall_gravity = 1.5
var scale_value:float # normalized scale
var is_on_ground = false # for jump
var set_gravity: bool = true
var upside_down: bool = false


@onready var mesh_instance: MeshInstance2D = $MeshInstance2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visible_on_screen_notifier: VisibleOnScreenEnabler2D = $visible_on_screen_notifier

@onready var ground_checker: Area2D = $ground_checker
#@onready var cpu_particles_2d: CPUParticles2D = $Ground_checker/CPUParticles2D
@onready var dissolve_timer: Timer = $dissolveTimer
#
@onready var mesh_og_size = Vector2(1,1)
@onready var collision_og_size = Vector2(1,1)
#
func _ready(pos=Vector2(-275,-45)) -> void:
	line_2d.position = mesh_instance.position
	dissolve_timer.start()
	mesh_instance.position = Vector2(0,0)
	mesh_instance.mesh.size = Vector2(1,1)
	collision_shape.shape.size = Vector2(1,1)
	
	SignalBus.level_complete.connect(_on_player_level_complete)
	pass
	#cpu_particles_2d.emitting = true

func _process(delta: float) -> void:
	
	mesh_instance.position.x += delta * SPEED
	collision_shape.position.x = mesh_instance.position.x
	visible_on_screen_notifier.position.x = mesh_instance.position.x
	ground_checker.position.x = mesh_instance.position.x
#
@onready var line_2d: Line2D = $Trail


func _physics_process(delta: float) -> void:
	_set_gravity()
	line_2d.add_point(Vector2(mesh_instance.global_position.x ,position.y + mesh_instance.scale.y * 0.4 * scale_value * (2 * int(not upside_down) - 1 )))
	if line_2d.get_point_count() > 1000:
		line_2d.remove_point(0)
	
	
var notpolaring: bool = true #to prevent mulitple polarises at once
func _input(event):
	
	#polarity changer
	if event.is_action_pressed("change_polarity") and is_on_ground and notpolaring:
		notpolaring = false
		change_polarity()
	
	#jump
	if Input.is_action_just_pressed("jump") and is_on_ground:
		apply_central_impulse(Vector2(0,-JUMP_FORCE)) 
	

#for jump and refill------------------------------------------------------------

#for having different gravity force for jump and fall
func _set_gravity():
	if set_gravity: 
		if upside_down: gravity_scale = -jump_gravity if linear_velocity.y > 0.0 else -fall_gravity
		else: gravity_scale = jump_gravity if linear_velocity.y < 0.0 else fall_gravity

func _on_ground_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("ground"):
		is_on_ground = false

func _on_ground_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("ground"):
		is_on_ground = true
	if body.is_in_group("refilling"):
		refill()

#refilling for player logic-----------------------------------------------------

func refill():
	dissolve_timer.stop()
	create_tween().tween_property(mesh_instance, "rotation_degrees", -15,0.5 )

func cancel_refill():
	dissolve_timer.start()
	create_tween().tween_property(mesh_instance, "rotation_degrees", 0,0.2 )
	
#-------------------------------------------------------------------------------

#dissolve logic---------------------------------------------------------------

func _on_dissolve_timer_timeout() -> void:
	scale_value -= SCALE_SPEED
	if scale_value <= 1:
		create_tween().tween_property(mesh_instance.mesh,"size",Vector2(mesh_og_size.x,scale_value),1)
		collision_shape.shape.size.y = scale_value 
		ground_checker.scale.y = scale_value
	else:
		create_tween().tween_property(mesh_instance.mesh, "size", Vector2(scale_value,scale_value),1 )
		collision_shape.shape.size = Vector2(scale_value,scale_value)
		ground_checker.scale = Vector2(scale_value,scale_value)
	
	if scale_value <= 0:
		gameOver()

#-------------------------------------------------------------------------------

#refilling----------------------------------------------------------------------

func refilling():
	scale_value += 0.2
	scale_value=scale_value
	if scale_value <= 1:
		create_tween().tween_property(mesh_instance.mesh,"size",Vector2(mesh_og_size.x,scale_value),0.3 )
		collision_shape.shape.size.y = scale_value
		ground_checker.scale.y = scale_value
	
	else:
		create_tween().tween_property(mesh_instance.mesh, "size", Vector2(scale_value,scale_value),0.3 )
		collision_shape.shape.size = Vector2(scale_value,scale_value)
		ground_checker.scale = Vector2(scale_value,scale_value)
	
		
#------------------------------------------------------------------------------

#change_polarity logic----------------------------------------------------------

@onready var back_to_earth_timer: Timer = $backToEathTimer
#@onready var polarity_shifter_effects: CPUParticles2D = $Ground_checker/polarityShifterEffects

func change_polarity():
	#polarity_shifter_effects.emitting = true
	set_collision_mask_value(1,false)
	set_collision_mask_value(3,true)
	back_to_earth_timer.start() # 0.3 secs
	#set_gravity turned off so that the fall graivty isnt applied to the polarity change, since increase in gravity
	#increase fall distance more than neccessary (different fall dist for diff polarity due to this error)
	#which happens because our polarity change depends on a timer rather than checking position
	set_gravity = false 

func _on_back_to_eath_timer_timeout() -> void:
	#changing the gravity related variables
	upside_down= not upside_down #inverting the value
	set_gravity = true #here turned on after fall to behave as usual
	JUMP_FORCE =- JUMP_FORCE
	#polarity_shifter_effects.gravity.y = - polarity_shifter_effects.gravity.y
	set_collision_mask_value(1,true)
	set_collision_mask_value(3,false)
	back_to_earth_timer.stop()
	
	notpolaring = true #now player can polar
	
#-------------------------------------------------------------------------------

#level complete-----------------------------------------------------------------

var level_complete: bool = false
@onready var camera_2d: Camera2D = $MeshInstance2D/Camera2D

func _on_player_level_complete():
	print("player: level_complete")
	level_complete = true
	dissolve_timer.stop()
	#adjusting the dissolved size to normal
	scale_value = 1
	create_tween().tween_property(mesh_instance.mesh,"size",Vector2(mesh_og_size.x,scale_value),3)
	collision_shape.shape.size = Vector2(scale_value,scale_value)
	ground_checker.scale = Vector2(scale_value,scale_value)
	#await create_tween().tween_property(mesh_instance, "rotation_degrees", 15,3).finished
	#create_tween().tween_property(camera_2d, "rotation_degrees", 45,3)
	#camera_2d.enabled = true


#-------------------------------------------------------------------------------
func _on_visible_on_screen_notifier_screen_exited() -> void:
	gameOver()
	
func gameOver():
	#cpu_particles_2d.emitting=false
	if not level_complete:
		SignalBus.game_over.emit()
		dissolve_timer.stop()
