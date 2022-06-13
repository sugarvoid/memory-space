extends Node2D

onready var tween = get_node("Tween")


const hover_color: Color = Color('FFA300')

var hold_time: int = 0 

func _ready() -> void:
	$AnimationPlayer.play("blink")
	tween.interpolate_property($AudioStreamPlayer, "volume_db", -80, 0, 1, 1, Tween.EASE_IN, 0)
	tween.start()
	$AudioStreamPlayer.play()
	$Sprite2/VBoxContainer/Normal.add_color_override("font_color", hover_color)

func _process(delta):
	if hold_time > 100:
		hold_time = 100
		
	if hold_time < 0:
		hold_time = 0 
		
	print(hold_time)
	if Input.is_action_pressed("space"):
		# Move as long as the key/button is pressed.
		hold_time += 1
	if !Input.is_action_pressed("space"):
		hold_time -= .5
	
	$TextureProgress.value = hold_time

func _input(event) -> void:
#	if (event.is_action_pressed("space")):
#		hold_time += 1
	if (event.is_action_released("space")):
		print(hold_time)
		##var _x = get_tree().change_scene("res://Game.tscn")
