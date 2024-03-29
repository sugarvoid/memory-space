extends Node2D

onready var tween = get_node("Tween")
onready var lbl_start = get_node("LblStart")


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
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()

####### REPLACE WITH STATE MACHINE ###########
	if (event.is_action_released("space")) and on_diff_selection:
		Global.game_mode = the_child
		var _x = get_tree().change_scene("res://Game.tscn")
			
	if (event.is_action_released("space")) and !on_diff_selection:
		$VBoxContainer.visible = true
		self.lbl_start.visible = false
		$AnimationPlayer.stop()
		on_diff_selection = true
	

func _step_through_modes():
	the_child += 1
	if the_child == 3:
		the_child = 0
	for c in $VBoxContainer.get_children():
		c.unhighlight()
	$VBoxContainer.get_child(the_child).highlight()

func _on_TimerCycle_timeout():
	_step_through_modes()
