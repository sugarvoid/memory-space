extends Node2D

onready var square0 = get_node("Row/Square0")
onready var square1 = get_node("Row/Square1")
onready var square2 = get_node("Row/Square2")
onready var square3 = get_node("Row/Square3")
onready var square4 = get_node("Row/Square4")


var current_pattern : Array = [
	2,0,1,2,3
]

var player_seleted_pattern : Array = [
	null, null, null, null, null
]

var player_current_guess: int = 0

func _ready():
	pass

func _process(delta):
	if player_current_guess == 5:
		$Wheel/Ball.stop_rotating()

func _show_desired_pattern() -> void:
	_setup_sprites()
	for n in $Row.get_children():
		n.flip_over()

func _hide_desired_pattern() -> void:
	_setup_sprites()
	for n in $Row.get_children():
		n.squre_sprite.frame = 4


func _setup_sprites() -> void:
	square0.color = current_pattern[0]
	square1.color = current_pattern[1]
	square2.color = current_pattern[2]
	square3.color = current_pattern[3]
	square4.color = current_pattern[4]

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print('player guess:')
		player_seleted_pattern[player_current_guess] = $Wheel/Ball.get_color()
		print($Wheel/Ball.get_color())
		print('actual color:')
		print($Row.get_child(player_current_guess).color)
		player_current_guess += 1
		#_show_desired_pattern()
	if event.is_action_pressed("ui_up"):
		#print($Wheel/Ball.get_color())
		_hide_desired_pattern()
		$Wheel/Ball.toggle_ball_roating()
