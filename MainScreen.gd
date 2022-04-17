extends Node2D


func _ready():
	$AnimationPlayer.play("blink")

func _input(event):
	if (event.is_action_released("space")):
		var _x = get_tree().change_scene("res://Game.tscn")
