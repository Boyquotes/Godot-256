extends NinePatchRect

onready var tween = $Tween
var actual_color = [1,1,1]


func _ready():
	pass # Replace with function body.


func lost_point():
	tween.interpolate_property(self, "rect_position",
rect_position, (rect_position + Vector2(100,0)), 0.5,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate",
Color(actual_color[0],actual_color[1],actual_color[2],1),
Color(actual_color[0],actual_color[1],actual_color[2],0), 0.5,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	queue_free()

func initial_setup(destiny,width):
	match destiny:
		"RANK":
			actual_color = [1,1,0]
		"LIFE":
			actual_color = [1,0,0]
		"STAMINA":
			actual_color = [0,1,0]
	modulate = Color(actual_color[0],actual_color[1],actual_color[2],1)
	rect_size.x = width
	patch_margin_left = width/2
	patch_margin_right = width/2

func set_dimention(width):
	rect_size.x = width
	patch_margin_left = width/2
	patch_margin_right = width/2

