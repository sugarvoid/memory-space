extends Area2D

export var color : String

func _ready():
	pass

func get_color() -> int:
	match(self.color):
		"green":
			return Global.COLORS.GREEN
		"red":
			return Global.COLORS.RED
		"blue":
			return Global.COLORS.BLUE
		"yellow":
			return Global.COLORS.YELLOW
		_:
			return -1
