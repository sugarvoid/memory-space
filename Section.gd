extends Node2D

var color : int 
var is_flipped_over : bool

onready var squre_sprite : Sprite = $Square
onready var result_sprite: Sprite = get_node("Result")

func _match_color_to_sprite() -> void:
	match(self.color):
		Global.COLORS.BLUE:
			squre_sprite.frame = 0
		Global.COLORS.YELLOW:
			squre_sprite.frame = 1
		Global.COLORS.RED:
			squre_sprite.frame = 2
		Global.COLORS.GREEN:
			squre_sprite.frame = 3


func set_result_sprite(correct: bool) -> void:
	if correct:
		result_sprite.frame = 0
	else:
		result_sprite.frame = 1


func show_result() -> void:
	result_sprite.visible = true

func hide_result() -> void:
	result_sprite.visible = false

func _ready() -> void:
	_reset_section()
	
	

func _reset_section() -> void:
	self.result_sprite.visible = false
	self.squre_sprite.frame = 4

func flip_over() -> void:
	$AnimationPlayer.play("y_scale_down")
	
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "y_scale_down":
		#change sprite to right frame
		_match_color_to_sprite()
		$AnimationPlayer.play("y_scale_up")
