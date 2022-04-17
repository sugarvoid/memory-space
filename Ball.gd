extends Sprite

var current_color : int = 0
var is_rotating: bool = false

func _ready():
	pass

func get_color() -> int:
	#return self.current_color
	return self.current_color

func _on_Area2D_area_entered(area):
	self.current_color = area.get_color()

func _physics_process(delta):
	rotate(delta)

func toggle_ball_roating() -> void:
	is_rotating = !is_rotating

func stop_rotating():
	is_rotating = false
	
func start_rotating():
	is_rotating = true

func rotate(delta):
	if is_rotating:
		self.rotation_degrees += 350 * delta
