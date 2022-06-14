extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var title: String


const HOVER_COLOR: Color = Color('FFA300')




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func highlight() -> void:
	self.add_color_override("font_color", HOVER_COLOR)


func unhighlight() -> void:
	self.add_color_override("font_color", Color.white)

