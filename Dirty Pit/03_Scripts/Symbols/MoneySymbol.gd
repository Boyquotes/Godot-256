extends AnimatedSprite

var dis_up = -40
var dis_down = 40
var dis_left = -40
var dis_right = 40

var start_pos
var wait_befor_appear

var mode = MODE.ALREADY_IN_GAME setget set_mode

enum MODE{
	ALREADY_IN_GAME,
	JUST_APPEAR
	FLY_DOWN,
	FLY_UP
}

func set_mode(value):
	mode = value
	



func _ready():
	match mode:
		0:
			pass
		1:
			position = start_pos
			appear_in_game()
		2:
			pass
	pass # Replace with function body.

func start_set_up(pos):
	randomize()
	start_pos = Vector2(pos.x+rand_range(dis_left,dis_right),pos.y+rand_range(dis_down,dis_up))
	wait_befor_appear = rand_range(0.2,1)
	scale = Vector2(0,0)
	set_mode(1)


func appear_in_game():
	$Tween.interpolate_property(self, "scale",
scale,Vector2(0.25,0.25), wait_befor_appear,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func fly_in():
	$Tween.interpolate_property(self, "position",
position,position+Vector2(200,0), 0.7,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)


func fly_out():
	set_mode(3)
	$Tween.interpolate_property(self, "position",
position,position-Vector2(200,0), 0.7,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_started(object, key):
	pass # Replace with function body.


func _on_Tween_tween_completed(object, key):
	match mode:
		0:
			pass
		1:
			fly_in()
			set_mode(2)
		2:
			set_mode(0)
		3:
			visible = false
