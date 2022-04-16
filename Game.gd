extends Node2D


var current_patten : Array = [
	2,2,2
]

func _ready():
	pass

func _input(event):
	if event.is_action_released("ui_accept"):
		print($Ball.get_color())
