extends Label


export var title: String


const HOVER_COLOR: Color = Color('FFA300')


func highlight() -> void:
	self.add_color_override("font_color", HOVER_COLOR)


func unhighlight() -> void:
	self.add_color_override("font_color", Color.white)

