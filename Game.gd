extends Node2D


const level_string = "Level: %s"

onready var square0 = get_node("Row/Square0")
onready var square1 = get_node("Row/Square1")
onready var square2 = get_node("Row/Square2")
onready var square3 = get_node("Row/Square3")
onready var square4 = get_node("Row/Square4")
onready var square_container = get_node("Row")


enum GAME_STATE {
	BEFORE_ROUND,
	DURING,
	POST_ROUND
}

var rng :RandomNumberGenerator
var current_level: int
var is_round_over: bool = false
var state = GAME_STATE.BEFORE_ROUND
var desired_pattern : Array = [null, null, null, null, null]
var player_seleted_pattern : Array = [null, null, null, null, null]
var player_current_guess: int


func _ready():
	current_level = 1
	rng = RandomNumberGenerator.new()


func _process(_delta):
	_update_level_label()
	
	match(state):
		GAME_STATE.BEFORE_ROUND:
			$AnimationPlayer.play("start_round")
		GAME_STATE.DURING:
			if player_current_guess == 5:
				$Wheel/Ball.stop_rotating()
				$Instructions2.visible = false
				self.state = GAME_STATE.POST_ROUND
		GAME_STATE.POST_ROUND:
			if !is_round_over:
				_check_results()
				$PostRoundTimer.start(4)
				is_round_over = true


func _update_level_label() -> void:
	$LblLevel.text = level_string % str(current_level)


func _reset_player_guess() -> void:
	player_current_guess = 0


func _generate_new_pattern() -> void:
	for n in 5:
		desired_pattern[n] = _get_random_number()


func _start_ball() -> void:
	$Wheel/Ball.start_rotating()


func _stop_ball() -> void:
	$Wheel/Ball.stop_rotating()


func _get_random_number() -> int:
	rng.randomize()
	return rng.randi_range(0, 3)


func _check_results() -> void:
	for n in 5:
		square_container.get_child(n).set_result_sprite(player_seleted_pattern[n] == desired_pattern[n])
		square_container.get_child(n).show_result()


func _show_desired_pattern() -> void:
	_setup_sprites(desired_pattern)
	for n in square_container.get_children():
		n.flip_over()


func _hide_desired_pattern() -> void:
	#_setup_sprites()
	for n in square_container.get_children():
		n.squre_sprite.frame = 4


func _setup_sprites(pattern: Array) -> void:
	square0.color = pattern[0]
	square1.color = pattern[1]
	square2.color = pattern[2]
	square3.color = pattern[3]
	square4.color = pattern[4]

func _input(event) -> void:
	match(state):
		GAME_STATE.DURING:
			if event.is_action_pressed("ui_accept"):
				player_seleted_pattern[player_current_guess] = $Wheel/Ball.get_color()
				square_container.get_child(player_current_guess).color = player_seleted_pattern[player_current_guess]
				square_container.get_child(player_current_guess).flip_over()
				player_current_guess += 1


func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == 'start_round':
		self.state = GAME_STATE.DURING


func _start_new_round() -> void:
	is_round_over = false
	player_current_guess = 0
	_generate_new_pattern()
	state = GAME_STATE.BEFORE_ROUND


func _on_PostRoundTimer_timeout() -> void:
	for n in square_container.get_children():
		n.hide_result()
		n.squre_sprite.frame = 4
	
	if(player_seleted_pattern == desired_pattern):
		current_level += 1
		_start_new_round()
	else:
		var _x = get_tree().change_scene("res://scene/GameOver.tscn")
