extends Node2D

const frames: Array = [
	8, 10, 11, 12
]

func _ready():
	randomize()
	var rand_int : int = randi() % frames.size()
	$Sprite.frame = frames[rand_int]

func _process(delta):
	self.global_position.y += 13 * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
