extends Node2D

onready var tween = get_node("Tween")

func _ready() -> void:
	$AnimationPlayer.play("blink")
	tween.interpolate_property($AudioStreamPlayer, "volume_db", -80, 0, 1, 1, Tween.EASE_IN, 0)
	tween.start()
	$AudioStreamPlayer.play()

func _input(event) -> void:
	if (event.is_action_released("space")):
		var _x = get_tree().change_scene("res://Game.tscn")
