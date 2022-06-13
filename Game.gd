extends Node2D


onready var square_container = get_node("SquareContainer")
onready var pSquare = preload("res://Section.tscn")
onready var starting_position: Vector2 = get_node("StartingPos").position


const level_string = "Level: %s"
const row_one_y = 55
const row_two_y = 95


enum GAME_STATE {
	BEFORE_ROUND,
	DURING,
	CHECKING,
	POST_ROUND
}

enum GAME_MODE {
	EASY,
	NORMAL,
	HARD
}

var rng :RandomNumberGenerator
var is_level_over: bool = false
var state = GAME_STATE.BEFORE_ROUND
var game_mode = GAME_MODE.NORMAL
var desired_pattern : Array
var player_seleted_pattern : Array
var player_current_guess: int
var w_space: int 
var done_checking: bool = false
var NORMAL_MODE_PATTERN: Array = []
var square_pos: Array



func _int_to_color(number: int) -> String:
	var strings: Array = [
		"Blue",
		"Yellow",
		"Red",
		"Green"
	]
	return strings[number]


func _ready():
	Global.current_level = 1
	rng = RandomNumberGenerator.new()
	_fill_in_postions()
	
	
	if game_mode == GAME_MODE.NORMAL:
		NORMAL_MODE_PATTERN.resize(50)
		_create_normal_pattern()
		
	_start_new_level()



func _add_squares():
	for c in square_container.get_children():
		c.queue_free()
	
	for l in Global.current_level:
		_spawnSquare(square_pos[l])


func _process(_delta):
	_update_level_label()
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	match(state):
		GAME_STATE.BEFORE_ROUND:
			$AnimationPlayer.play("start_round")
		GAME_STATE.DURING:
			if player_current_guess == Global.current_level:
				$Wheel/Ball.stop_rotating()
				$Instructions2.visible = false
				self.state = GAME_STATE.CHECKING
		GAME_STATE.CHECKING:
			_compare_squares()
			self.state = GAME_STATE.POST_ROUND
		GAME_STATE.POST_ROUND:
			if !is_level_over and done_checking:
				_check_results()
				$PostRoundTimer.start(4)
				is_level_over = true
				done_checking = false


func _create_normal_pattern() -> void:
	for i in 50:
		NORMAL_MODE_PATTERN[i] = _get_random_number()


func _update_level_label() -> void:
	$LblLevel.text = level_string % str(Global.current_level)


func _compare_squares() -> void:
	#print(square_container.get_children())
	for c in square_container.get_children():
		c.flip_over()
		yield(get_tree().create_timer(1), "timeout")
	done_checking = true


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
	self.player_seleted_pattern.clear()
	self.player_seleted_pattern.resize(cur_lvl)


func _reset_player_guess() -> void:
	player_current_guess = 0


func _generate_level_pattern() -> void:
	match(game_mode):
		GAME_MODE.EASY:
			desired_pattern = Global.EASY_MODE_PATTERN.slice(0, (Global.current_level - 1) )
		GAME_MODE.NORMAL:
			desired_pattern = NORMAL_MODE_PATTERN.slice(0, (Global.current_level - 1) )
		GAME_MODE.HARD:
			for n in Global.current_level:
				desired_pattern[n] = _get_random_number()


func _start_ball() -> void:
	$Wheel/Ball.start_rotating()


func _stop_ball() -> void:
	$Wheel/Ball.stop_rotating()


func _get_random_number() -> int:
	rng.randomize()
	return rng.randi_range(0, 3)


func _check_results() -> void:
	for n in Global.current_level:
		pass
		#square_container.get_child(n).set_result_sprite(player_seleted_pattern[n] == desired_pattern[n])
		#square_container.get_child(n).show_result()



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
		c.color = pattern[c.get_index()]
	

func _input(event) -> void:
	match(state):
		GAME_STATE.DURING:
			var current_square: Section = square_container.get_child(player_current_guess)
			if event.is_action_pressed("ui_accept"):
				player_seleted_pattern[player_current_guess] = $Wheel/Ball.get_color()
				current_square.set_guess_sprite(player_seleted_pattern[player_current_guess])
				current_square.show_player_guess()
				#current_square.color = player_seleted_pattern[player_current_guess]
				#current_square.flip_over()
				player_current_guess += 1


func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == 'start_round':
		self.state = GAME_STATE.DURING


func _start_new_level() -> void:
	print('hello')
	is_level_over = false
	player_current_guess = 0
	
	_resizeArrays(Global.current_level)
	
	_generate_level_pattern()

	_add_squares()
	state = GAME_STATE.BEFORE_ROUND


func _on_PostRoundTimer_timeout() -> void:
	for n in square_container.get_children():
		n.hide_player_guess()
		n.squre_sprite.frame = 4
	
	if(player_seleted_pattern == desired_pattern):
		Global.current_level += 1
		_start_new_level()
	else:
		var _x = get_tree().change_scene("res://scene/GameOver.tscn")
