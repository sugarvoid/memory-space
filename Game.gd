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


var square_pos: Array


func _ready():
	current_level = 1
	
	_fill_in_postions()
	
	rng = RandomNumberGenerator.new()
	
	_add_squares()


func _add_squares():
	
	for c in square_container.get_children():
		c.queue_free()
	
	for l in current_level:
		_spawnSquare(square_pos[l])

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
	var x_value = starting_position.x
	
	for l in 100:
		
		if l == 10:
			y_value = y_value + 70
			x_value = starting_position.x
		if l == 20:
			y_value = y_value + 70
			x_value = starting_position.x
			#x_value = x_value + 40
		if l == 30:
			y_value = y_value + 70
			x_value = starting_position.x
			#x_value = x_value + 40
		if l == 40:
			y_value = y_value + 70
			x_value = starting_position.x
			#x_value = x_value + 40
		if l == 50:
			y_value = y_value + 70
			x_value = starting_position.x
			#x_value = x_value + 40
		
		x_value += 40
		var tempPos: Vector2 = Vector2(x_value, y_value)
		
		self.square_pos.append(tempPos)
	



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
	for n in self.current_level:
		pass
		#square_container.get_child(n).set_result_sprite(player_seleted_pattern[n] == desired_pattern[n])
		#square_container.get_child(n).show_result()
	
	print(desired_pattern)
	print(player_seleted_pattern)


func _show_desired_pattern() -> void:
	_setup_sprites(desired_pattern)
	for n in square_container.get_children():
		n.flip_over()


func _hide_desired_pattern() -> void:
	#_setup_sprites()
	for n in square_container.get_children():
		n.squre_sprite.frame = 4


func _setup_sprites(pattern: Array) -> void:
	for c in $SquareContainer.get_children():
		c.color = desired_pattern[c.get_index()]

	

func _input(event) -> void:
	match(state):
		GAME_STATE.DURING:
			if event.is_action_pressed("ui_accept"):
				player_seleted_pattern[player_current_guess] = $Wheel/Ball.get_color()
				square_container.get_child(player_current_guess).set_guess_sprite(player_seleted_pattern[player_current_guess])
				square_container.get_child(player_current_guess).show_player_guess()
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
	_add_squares()
	state = GAME_STATE.BEFORE_ROUND


func _on_PostRoundTimer_timeout() -> void:
	for n in square_container.get_children():
		n.hide_player_guess()
		n.squre_sprite.frame = 4
	
	if(player_seleted_pattern == desired_pattern):
		current_level += 1
		_start_new_level()
	else:
		var _x = get_tree().change_scene("res://scene/GameOver.tscn")
