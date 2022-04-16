extends Sprite

var current_color : int = 0

func _ready():
	pass

func get_color() -> int:
	#return self.current_color
	return Global.COLORS_2[self.current_color]

func _on_Area2D_area_entered(area):
	self.current_color = area.get_color()

func _process(delta):
	rotate(delta)


func rotate(delta):
	self.rotation_degrees += 350 * delta
