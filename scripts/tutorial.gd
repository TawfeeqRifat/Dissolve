extends Node2D


@onready var tutorial_instructions: Label = $"../Tutorial_HUD/Tutorial_Instructions"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and jumpSet:
		jumpSet = false
		await get_tree().create_timer(1).timeout
		tutorial_instructions.text = ""
	if event.is_action_pressed("change_polarity") and polaritySet:
		polaritySet = false
		await get_tree().create_timer(1).timeout
		tutorial_instructions.text = "Nice"
		await get_tree().create_timer(1).timeout
		tutorial_instructions.text = ""
		

var jumpSet = false
func _on_jump_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		tutorial_instructions.text = "press space to jump"
		jumpSet = true
	


func _on_jump_success_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		tutorial_instructions.text = "Nice"
		await get_tree().create_timer(0.5).timeout
		tutorial_instructions.text = ""


var polaritySet = false
func _on_polarize_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		tutorial_instructions.text = "press z"
		polaritySet = true
