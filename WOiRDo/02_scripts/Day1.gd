extends Control

var daytween

var day_name = ""
var day_nr
var month_nr
var year_nr

var but_pressed=false
var delete_day_mode_on=false


func _ready():
	$Button/Sign.read_sign(day_name)
	pass # Replace with function body.

func bb_start_params(day,m,y,tween):
	day_name = str(day)
	day_nr=day
	month_nr=m
	year_nr=y
	daytween=tween


func _on_Button_button_down():
	but_pressed=true
	daytween.bb_animate_pressing_button(day_nr,month_nr,year_nr)
func _on_Button_button_up():
	if but_pressed:
		but_pressed=false
		daytween.bb_animatation_stopped(day_nr,month_nr,year_nr)
		match delete_day_mode_on:
			false:
				Signals.emit_signal("show_words_from_day",day_nr,month_nr,year_nr)
			true:
				Signals.emit_signal("delete_whole_day",day_nr,month_nr,year_nr)
func _on_Button_toggled(button_pressed):
	pass # Replace with function body.




