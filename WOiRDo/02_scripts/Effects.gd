extends Control

var sign_start_pos = Vector2(0,210)
var sign_end_pos = Vector2(0,30)
var time = 2

func _ready():
	pass # Replace with function body.

func bb_show_success():
	$SignSuccess.visible=true
	$Tween.interpolate_property($SignSuccess,"rect_position",sign_start_pos,sign_end_pos,
		time,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($SignSuccess,"modulate",Color(1,1,1,1),Color(1,1,1,0),
		time,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func bb_show_fail():
	$SignFail.visible=true
	$Tween.interpolate_property($SignFail,"rect_position",sign_start_pos,sign_end_pos,
		time,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($SignFail,"modulate",Color(1,1,1,1),Color(1,1,1,0),
		time,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func bb_reset():
	$SignSuccess.visible=false
	$SignFail.visible=false
	$Tween.stop($SignSuccess,"rect_position")
	$Tween.stop($SignFail,"rect_position")
	$SignSuccess.modulate=Color(1,1,1,1)
	$SignFail.modulate=Color(1,1,1,1)
	$SignSuccess.rect_position=sign_start_pos
	$SignFail.rect_position=sign_start_pos




