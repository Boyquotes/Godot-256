extends Control

export var day_border = 40
export var week_border = 50
export var month_border = 60
export var full_border = 600



func _ready():
	bb_show_titles()
	pass # Replace with function body.

func bb_show_titles():
	get_node("Daily/InDay/Sign").read_sign("Daily")
	get_node("Weekly/InWeek/Sign").read_sign("Weekly")
	get_node("Monthly/InMonth/Sign").read_sign("Monthly")
	get_node("Full/InOverall/Sign").read_sign("Overall")

func bb_show_numbers():
	var date=OS.get_date()
	var days=Content.bb_give_me_nr_words_in_day(date["year"],date["month"],date["day"])[0]
	var weeks=Content.bb_give_me_words_in_last_week(date["year"],date["month"],date["day"])[0]
	var months=Content.bb_give_me_words_in_last_month(date["year"],date["month"],date["day"])[0]
	var full=Content.bb_give_me_words_from_full_content()[0]
	get_node("Daily/InDay/Sign2").read_sign(str(days))
	get_node("Weekly/InWeek/Sign2").read_sign(str(weeks))
	get_node("Monthly/InMonth/Sign2").read_sign(str(months))
	get_node("Full/InOverall/Sign2").read_sign(str(full))

func bb_check_is_number_is_valid(mode):
	var date=OS.get_date()
	var days=Content.bb_give_me_nr_words_in_day(date["year"],date["month"],date["day"])[0]
	var weeks=Content.bb_give_me_words_in_last_week(date["year"],date["month"],date["day"])[0]
	var months=Content.bb_give_me_words_in_last_month(date["year"],date["month"],date["day"])[0]
	var full=Content.bb_give_me_words_from_full_content()[0]
	match mode:
		0:
			if days<day_border:
				Signals.emit_signal("show_warning4",day_border)
				return true
		1:
			if weeks<week_border:
				Signals.emit_signal("show_warning4",week_border)
				return true
		2:
			if months<month_border:
				Signals.emit_signal("show_warning4",month_border)
				return true
		3:
			if full<full_border:
				Signals.emit_signal("show_warning4",full_border)
				return true
	return false



func bb_start_quest(base,mode,type_of_arena):
	var arena = get_node("../Arena")
	arena.bb_draw_words(base,mode)
	arena.type_of_arena=type_of_arena
	get_node("../../Keyboard").mode=1
	get_node("../../MainAnim").play("06_hide_pickmode_show_arena")



func _on_Daily_button_down():
	get_parent().but_pressed=true
	get_parent().challangetween.bb_animate_pressing_button(3)
func _on_Daily_button_up():
	if get_parent().but_pressed:
		get_parent().but_pressed=false
		get_parent().challangetween.bb_animatation_stopped(3)
		if bb_check_is_number_is_valid(0):
			return
		var date=OS.get_date()
		var words = Content.bb_give_me_nr_words_in_day(date["year"],date["month"],date["day"])[1]
		bb_start_quest(words,day_border,0)
func _on_Daily_toggled(button_pressed):
	pass # Replace with function body.


func _on_Weekly_button_down():
	get_parent().but_pressed=true
	get_parent().challangetween.bb_animate_pressing_button(4)
func _on_Weekly_button_up():
	if get_parent().but_pressed:
		get_parent().but_pressed=false
		get_parent().challangetween.bb_animatation_stopped(4)
		if bb_check_is_number_is_valid(1):
			return
		var date=OS.get_date()
		var words = Content.bb_give_me_words_in_last_week(date["year"],date["month"],date["day"])[1]
		bb_start_quest(words,week_border,1)
func _on_Weekly_toggled(button_pressed):
	pass # Replace with function body.


func _on_Monthly_button_down():
	get_parent().but_pressed=true
	get_parent().challangetween.bb_animate_pressing_button(5)
func _on_Monthly_button_up():
	if get_parent().but_pressed:
		get_parent().but_pressed=false
		get_parent().challangetween.bb_animatation_stopped(5)
		if bb_check_is_number_is_valid(2):
			return
		var date=OS.get_date()
		var words = Content.bb_give_me_words_in_last_month(date["year"],date["month"],date["day"])[1]
		bb_start_quest(words,month_border,2)
func _on_Monthly_toggled(button_pressed):
	pass # Replace with function body.


func _on_Full_button_down():
	get_parent().but_pressed=true
	get_parent().challangetween.bb_animate_pressing_button(6)
func _on_Full_button_up():
	if get_parent().but_pressed:
		get_parent().but_pressed=false
		get_parent().challangetween.bb_animatation_stopped(6)
		if bb_check_is_number_is_valid(3):
			return
		var words = Content.bb_give_me_words_from_full_content()[1]
		bb_start_quest(words,full_border,3)
func _on_Full_toggled(button_pressed):
	pass # Replace with function body.


