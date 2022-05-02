extends Node2D


func _ready() -> void:
	pass


func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if(anim_name == 'rise_up'):
		var _x = get_tree().change_scene("res://scene/MainScreen.tscn")


func _on_TimerDelay_timeout():
	$AnimationPlayer.play("rise_up")
	$AudioStreamPlayer.play()
