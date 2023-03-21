extends Control

var nr_of_snakes = 3
onready var change_snake_anim = $ChangeSnakeAnim
onready var button_tween = $ButtonTween

var snake_nr = 1
var fading = false
var ChangeSnakeAnim_is_playing = false

var snake_1_muted = false
var snake_2_muted = false
var snake_3_muted = false

func _ready():
	disable_buttons()
	enable_buttons_for_one_snake()
	bb_start_setup()


func bb_start_setup():
	$ChangeSnakeAnim.set_current_animation("2_Snake3_to_Snake1")





func show_next_snake(actual_snake_nr):
	var next_nr
	if actual_snake_nr == nr_of_snakes:
		next_nr = 1
	else:
		next_nr = actual_snake_nr+1
	snake_nr = next_nr
	var anim_to_play
	match actual_snake_nr:
		1:
			anim_to_play = "0_Snake1_to_Snake2"
		2:
			anim_to_play = "1_Snake2_to_Snake3"
		3:
			anim_to_play = "2_Snake3_to_Snake1"
	change_snake_anim.play(anim_to_play)

func show_previous_hero(actual_snake_nr):
	var previous_nr
	if actual_snake_nr == 1:
		previous_nr = nr_of_snakes
	else:
		previous_nr = actual_snake_nr-1
	snake_nr = previous_nr
	var anim_to_play
	match actual_snake_nr:
		1:
			anim_to_play = "2_Snake3_to_Snake1"
		2:
			anim_to_play = "0_Snake1_to_Snake2"
		3:
			anim_to_play = "1_Snake2_to_Snake3"
	change_snake_anim.play_backwards(anim_to_play)

func bb_update_score_in_ChooseSnake(value):
	var short = "Snake"+str(snake_nr)
	get_node("SnakesButtons/Snake"+str(snake_nr)+"/Snake"+str(snake_nr)+"/VBox/Score/TextureRect/Margin/Sign").read_sign(str(value))

func bb_show_number_in_score_circle(snake_nr,score):
	var sign_circle = get_node("SnakesButtons/Snake"+str(snake_nr)+"/Snake"+str(snake_nr)+"/VBox/Score/TextureRect/Margin/Sign")
	sign_circle.read_sign(str(score))


func _on_Snake1_button_down():
	button_tween.bb_animate_pressing_button(1,1)
func _on_Snake1_button_up():
	button_tween.bb_animatation_stopped()
	bb_play_snake(1)

func _on_Snake2_button_down():
	button_tween.bb_animate_pressing_button(2,1)
func _on_Snake2_button_up():
	button_tween.bb_animatation_stopped()
	bb_play_snake(2)

func _on_Snake3_button_down():
	button_tween.bb_animate_pressing_button(3,1)
func _on_Snake3_button_up():
	button_tween.bb_animatation_stopped()
	bb_play_snake(3)

func _on_Mute_snake1_button_button_down():
	button_tween.bb_animate_pressing_button(1,2)
func _on_MuteSnake1_button_up():
	button_tween.bb_animatation_stopped()
	InGameSignals.emit_signal("mute_snake_button_pressed",1)
	bb_change_mute_button_visual(snake_nr)
func _on_Mute_snake2_button_button_down():
	pass # Replace with function body.
func _on_MuteSnake2_button_up():
	InGameSignals.emit_signal("mute_snake_button_pressed",2)
	bb_change_mute_button_visual(snake_nr)
func _on_Mute_snake3_button_button_down():
	pass # Replace with function body.
func _on_MuteSnake3_button_up():
	InGameSignals.emit_signal("mute_snake_button_pressed",3)
	bb_change_mute_button_visual(snake_nr)



func disable_buttons():
	for snake_node in $SnakesButtons.get_children():
		for button_con in snake_node.get_child(0).get_child(0).get_children():
			if not button_con.name =="Score":
				button_con.get_child(0).disabled = true

func enable_buttons_for_one_snake():
	var short = "Snake" + str(snake_nr)
	for button_con in $SnakesButtons.get_node(short).get_child(0).get_child(0).get_children():
		if not button_con.name =="Score":
			button_con.get_child(0).disabled = false

func enable_buttons():
	for snake_node in $SnakesButtons.get_children():
		for button_con in snake_node.get_child(0).get_child(0).get_children():
			if not button_con.name =="Score":
				button_con.get_child(0).disabled = false



func bb_play_snake(nr):
	disable_buttons()
	$AnimP.play("fade_away")


func bb_emit_signal_snake_was_choosen():
	if not fading:
		InGameSignals.emit_signal("snake_was_choosen",snake_nr)
		InGameSignals.emit_signal("snake_was_choosen_so_activate_interface")


func bb_on_show_choose_snake_panel():
	fading = true
	get_node("../MainCamera").current = true
	$AnimP.play_backwards("fade_away")


func _on_AnimP_animation_finished(anim_name):
	if fading:
		enable_buttons_for_one_snake()
		fading = false

func bb_change_mute_button_visual(nr):
	var button_texture = get_node("SnakesButtons/Snake"+str(nr)+"/Snake"+str(nr)+"/VBox/Mute/Mute_snake"+str(nr)+"_button/Texture")
	if get("snake_"+str(nr)+"_muted"):
		button_texture.modulate = Color(1,1,1,1)
		set("snake_"+str(nr)+"_muted",false)
	else:
		button_texture.modulate = Color(0,0,0,1)
		set("snake_"+str(nr)+"_muted",true)








func _on_DeleteSnake1_button_up():
	InGameSignals.emit_signal("delete_snake",1)
	InGameSignals.emit_signal("clear_snakes_world",1)
	bb_show_number_in_score_circle(1,0)

func _on_DeleteSnake2_button_up():
	InGameSignals.emit_signal("delete_snake",2)
	InGameSignals.emit_signal("clear_snakes_world",2)
	bb_show_number_in_score_circle(2,0)

func _on_DeleteSnake3_button_up():
	InGameSignals.emit_signal("delete_snake",3)
	InGameSignals.emit_signal("clear_snakes_world",3)	
	bb_show_number_in_score_circle(3,0)



func _on_PlayButton_button_down():
	InGameSignals.emit_signal("mute_snake_button_pressed",1)
func _on_PlayButton_button_up():
	InGameSignals.emit_signal("mute_snake_button_pressed",1)
func _on_PlayButton_toggled(button_pressed):
	bb_play_snake(1)


func _on_Previous_button_up():
	if not ChangeSnakeAnim_is_playing:
		disable_buttons()
		show_previous_hero(snake_nr)
		ChangeSnakeAnim_is_playing = true

func _on_Next_button_up():
	if not ChangeSnakeAnim_is_playing:
		disable_buttons()
		show_next_snake(snake_nr)
		ChangeSnakeAnim_is_playing = true

func _on_ChangeSnakeAnim_animation_finished(anim_name):
	enable_buttons_for_one_snake()
	ChangeSnakeAnim_is_playing = false








func _on_Settings_button_button_down():
	pass # Replace with function body.
func _on_Settings_button_button_up():
	disable_buttons()
	InGameSignals.emit_signal("show_settings")
