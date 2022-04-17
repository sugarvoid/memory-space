extends Node2D


func _ready():
	$AnimationPlayer.play("rise_up")
	$AudioStreamPlayer.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == 'rise_up'):
		var _x = get_tree().change_scene("res://MainScreen.tscn")
