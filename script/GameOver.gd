extends Node2D

var p_square = preload("res://FallingSqure.tscn")

func _ready() -> void:
	$AnimationPlayer.play("blink")
	$AudioStreamPlayer.play()


func _input(event) -> void:
	if (event.is_action_pressed("space")):
		$AudioStreamPlayer.stop()
		var _x = get_tree().change_scene("res://Game.tscn")


func _on_TimerSquareSpawn_timeout():
	var square = p_square.instance()
	square.position = $SquareSpawnPoint.position
	get_tree().current_scene.call_deferred("add_child", square)
