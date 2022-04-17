extends Sprite

var color : int 
var is_flipped_over : bool

func _match_color_to_sprite() -> void:
	match(self.color):
		Global.COLORS.BLUE:
			pass
		Global.COLORS.YELLOW:
			pass
		Global.COLORS.RED:
			pass
		Global.COLORS.GREEN:
			pass

func _ready() -> void:
	_match_color_to_sprite()
	


func flip_over() -> void:
	$AnimationPlayer.play("y_scale_down")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "y_scale_down":
		#change sprite to right frame
		self.frame = 3
		$AnimationPlayer.play("y_scale_up")
