extends Node2D


func _ready() -> void:
	pass


func _input(event) -> void:
	if (event.is_action_pressed("space")):
		var _x = get_tree().change_scene("res://Game.tscn")
