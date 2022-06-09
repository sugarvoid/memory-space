extends Node2D
class_name Section

var color : int 
var is_flipped_over : bool

onready var squre_sprite : Sprite = $Square
onready var guess_sprite: Sprite = get_node("PlayerGuess")

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



func set_guess_sprite(color: int) -> void:
	guess_sprite.frame = color


func show_player_guess() -> void:
	guess_sprite.visible = true


func hide_player_guess() -> void:
	guess_sprite.visible = false


func _ready() -> void:
	_reset_section()


func _reset_section() -> void:
	self.guess_sprite.visible = false
	self.squre_sprite.frame = 4


func flip_over() -> void:
	$AnimationPlayer.play("y_scale_down")


func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == "y_scale_down":
		#change sprite to right frame
		_match_color_to_sprite()
		$AnimationPlayer.play("y_scale_up")
