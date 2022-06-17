extends Node2D

const level_string = "You made it to level %s"
const mode_string = "%s Mode"


var p_square = preload("res://FallingSqure.tscn")



func _ready() -> void:
	$AnimationPlayer.play("blink")
	$AudioStreamPlayer.play()
	
	$Progress.text = level_string % str(Global.current_level)
	$LblMode.text = mode_string % Global.get_mode_string()


func _input(event) -> void:
	if (event.is_action_pressed("space")):
		$AudioStreamPlayer.stop()
		var _x = get_tree().change_scene(Global.path_to_main_menu)


func _on_TimerSquareSpawn_timeout():
	var square = p_square.instance()

	square.position = $SquareSpawnPoint.position
	get_tree().current_scene.call_deferred("add_child", square)
