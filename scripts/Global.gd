extends Node

const LEVEL_SELECTION_MENU = "res://Scenes/level_select_menu.tscn"
const MAIN_MENU = "res://Scenes/main_menu.tscn"
const PLAYER = preload("res://Scenes/player_revised.tscn")
const LEVEL_SELECT_BUTTON = "res://Scenes/level_select_button.tscn"
var all_levels = []
var unlocked_levels = 1
var total_levels = 5
