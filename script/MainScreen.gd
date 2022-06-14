extends Node2D

onready var tween = get_node("Tween")


const hover_color: Color = Color('FFA300')

var the_child: int = 0 
var on_diff_selection: bool

func _ready() -> void:
	_step_through_modes()
	$TimerCycle.start(1.5)
	on_diff_selection = false
	$AnimationPlayer.play("blink")
	tween.interpolate_property($AudioStreamPlayer, "volume_db", -80, 0, 1, 1, Tween.EASE_IN, 0)
	tween.start()
	$AudioStreamPlayer.play()


func _input(event) -> void:
#	if (event.is_action_pressed("space")):
#		hold_time += 1
####### REPLACE WITH STATE MACHINE ###########
	if (event.is_action_released("space")) and on_diff_selection:
		print(the_child)
		Global.game_mode = the_child
		var _x = get_tree().change_scene("res://Game.tscn")
			
	if (event.is_action_released("space")) and !on_diff_selection:
		$Sprite2/VBoxContainer.visible = true
		$Sprite2/Label.visible = false
		$AnimationPlayer.stop()
		
		##var _x = get_tree().change_scene("res://Game.tscn")
		on_diff_selection = true
	

func _step_through_modes():
	the_child += 1
	if the_child == 3:
		the_child = 0
	for c in $Sprite2/VBoxContainer.get_children():
		c.unhighlight()
	$Sprite2/VBoxContainer.get_child(the_child).highlight()

func _on_TimerCycle_timeout():
	_step_through_modes()
