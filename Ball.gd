extends Sprite

var current_color : int 

func _ready():
	pass

func get_color() -> int:
	return 1

func _on_Area2D_area_entered(area):
	self.current_color = area.get_color()

func _process(delta):
	rotate(delta)


func rotate(delta):
	self.rotation_degrees += 200 * delta
