extends Node2D

@export var buttonName : String

@onready var button: Button = $Button

func _ready() -> void:
	button.text = buttonName
