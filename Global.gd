extends Node

enum COLORS {
	BLUE,
	YELLOW,
	RED,
	GREEN
}

enum GAME_MODE {
	EASY,
	NORMAL,
	HARD
}

var game_mode: int

const path_to_main_menu: String = "res://scene/MainScreen.tscn"

const COLORS_2 : Dictionary = {
	0: "Blue",
	1: "Yellow",
	2: "Red",
	3: "Green"
}

const EASY_MODE_PATTERN: Array = [
	0, 3, 1, 3, 1, 3, 2, 0, 1, 2, 
	3, 1, 2, 3, 0, 1, 0, 1, 0, 3, 
	2, 1, 2, 3, 0, 1, 3, 0, 2, 3, 
	0, 3, 1, 0, 3, 0, 2, 3, 0, 3, 
	0, 3, 1, 0, 3, 2, 1, 2, 1, 2
]

var current_level: int

func _ready():
	OS.window_size = Vector2(1280, 720)

func get_mode_string() -> String:
	var mode_text : String
	match(Global.game_mode):
		0:
			mode_text = "Easy"
		1:
			mode_text = "Normal"
		2:
			mode_text = "Hard"
	
	return mode_text


