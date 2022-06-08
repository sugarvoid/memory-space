extends Node2D


const level_string = "Level: %s"

onready var square_container = get_node("SquareContainer")

onready var pSquare = preload("res://Section.tscn")


onready var starting_position: Vector2 = get_node("StartingPos").position


enum GAME_STATE {
	BEFORE_ROUND,
	DURING,
	POST_ROUND
}

var rng :RandomNumberGenerator
var current_level: int
var is_round_over: bool = false
var state = GAME_STATE.BEFORE_ROUND
var desired_pattern : Array
var player_seleted_pattern : Array
var player_current_guess: int
var w_space: int 

const row_one_y = 55
const row_two_y = 95

var buttface: Array

var square_pos: Array = [
	Vector2(250, 55),
	Vector2(290, 55),
	Vector2(330, 55),
	Vector2(370, 55),
	Vector2(410, 55),
	Vector2(450, 55),
	Vector2(490, 55),
	Vector2(530, 55),
	Vector2(570, 55),
	Vector2(610, 55),
	Vector2(650, 55),
	#
	#
	#
]


func _ready():
	current_level = 50
	
	_fill_in_postions()
	
	rng = RandomNumberGenerator.new()
	
	for l in current_level:
		print(l)
		_spawnSquare(buttface[l])


func _process(_delta):
	
	
	
	_update_level_label()
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	match(state):
		GAME_STATE.BEFORE_ROUND:
			$AnimationPlayer.play("start_round")
		GAME_STATE.DURING:
			if player_current_guess == self.current_level:
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


## Might add a fucntion to make positions in code
func _fill_in_postions() -> void:
	var y_value = starting_position.y
	for l in 100:
		var tempPos: Vector2 = Vector2(starting_position.x + (40 * l), starting_position.y)
		if l == 10:
			y_value = y_value + 40
		if l == 20:
			y_value = y_value + 40
		if l == 30:
			y_value = y_value + 40
		if l == 40:
			y_value = y_value + 40
		if l == 50:
			y_value = y_value + 40
		
		self.buttface.append(tempPos)
	
	print(self.buttface)


func _spawnSquare(pos: Vector2) -> void:
	var new_square = pSquare.instance()
	new_square.position = pos
	$SquareContainer.add_child(new_square)

func _resizeArrays(cur_lvl: int):
	self.desired_pattern.resize(cur_lvl)
	self.player_seleted_pattern.resize(cur_lvl)

func _reset_player_guess() -> void:
	player_current_guess = 0


func _generate_new_pattern() -> void:
	_resizeArrays(self.current_level)
	for n in self.current_level:
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
	$SquareContainer.get_child(0)
	$SquareContainer.get_child(1)
	$SquareContainer.get_child(2)
	

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


func _start_new_level() -> void:
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
		_start_new_level()
	else:
		var _x = get_tree().change_scene("res://scene/GameOver.tscn")
