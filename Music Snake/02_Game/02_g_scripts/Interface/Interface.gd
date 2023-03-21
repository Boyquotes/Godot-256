extends Control


export (NodePath) var score_sign_path 
export (NodePath) var bars_nr_sign_path
export (NodePath) var sixteenths_sign_path
export (NodePath) var metre_path

var fading = false

func _ready():
	set_process(false)
#	set_physics_process(false)
	get_node("../FullColorRect").modulate = Color(1,1,1,1)
	get_node("Bars/MarginContainer2/Sign").read_sign("BAR")
	get_node("Sixteens/MarginContainer2/Sign").read_sign("16TH")
	get_node("Sixteens/MarginContainer3/Sign").read_sign("IN BAR")
	pass # Replace with function body.

func _process(delta):
	rect_position = bb_set_position()

#func _physics_process(delta):
#	rect_position = bb_set_position()

func bb_set_position():
	var nr = str(get_node("../Player").snake_on_screen)
	var pos_A = -get_node("../Player/Snake"+nr+"/Head").get_viewport().canvas_transform.origin
	return pos_A

#func bb_change_score(number,not_important_value):
#	if typeof(number)==TYPE_INT:
##		get_node("TextureRect/MarginContainer/Sign").read_sign(str(number)) 
#		get_node("TextureRect/MarginContainer/Sign").read_sign(str(000)) 
#	else:
#		push_error("Wrong variant type!")
func bb_read_sixteen_and_bar_nr(score):
	var timing_bot =get_node(metre_path).metre_bot
	var timing_top =get_node(metre_path).metre_top
	var number_of_sixteens = 16/timing_bot*timing_top
	var bar_nr = ceil(1.0*score/number_of_sixteens)
	var order_nr_but_in_first_bar = score-floor((score-1)/number_of_sixteens)*number_of_sixteens
	get_node(bars_nr_sign_path).read_sign(str(bar_nr))
	get_node(sixteenths_sign_path).read_sign(str(order_nr_but_in_first_bar))


func bb_read_bar_in_song():
	pass

func bb_update_score(number):
	if typeof(number)==TYPE_INT:
		get_node(score_sign_path).read_sign(str(number)) 
		bb_read_sixteen_and_bar_nr(number)
	else:
		push_error("Wrong variant type!")
func bb_activate_interface():
	rect_position = bb_set_position()
	set_process(true)
#	set_physics_process(true)
	fading = true
	bb_update_score(get_node("../Player/Snake"+str(get_node("../Player").snake_on_screen)).nr_of_elements)
	$AnimPlayer.play_backwards("Interface_fade_away")



func _on_PauseGame_button_down():
	GlobalSignals.emit_signal("make_click_sound", 1)
func _on_PauseGame_button_up():
	$PauseGame.disabled = true
	GlobalSignals.emit_signal("make_click_sound", 1)
	$AnimPlayer.play("Interface_fade_away")



func bb_emit_pause_signals():
	if not fading:
		set_process(false)
#		set_physics_process(false)
		InGameSignals.emit_signal("show_choose_snake_panel")
		InGameSignals.emit_signal("pause_snake")
		InGameSignals.emit_signal("pause_world")



func _on_AnimPlayer_animation_finished(anim_name):
	if fading:
		get_node("PauseGame").disabled = false
		fading = false
