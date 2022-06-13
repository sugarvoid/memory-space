extends Node2D


onready var anim_logo: AnimationPlayer = get_node("AnimationPlayer")
onready var audio_logo: AudioStreamPlayer = get_node("AudioStreamPlayer")

func _ready() -> void:
	pass


func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if(anim_name == 'rise_up'):
		var _x = get_tree().change_scene(Global.path_to_main_menu)


func _on_TimerDelay_timeout():
	anim_logo.play("rise_up")
	audio_logo.play()
