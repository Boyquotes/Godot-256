extends Control

export(NodePath) var ScreenTween

var but_pressed=false

var woirdo = ""
var meaning = ""
var on_screen = "A"
export var letter_size=156

var change_word_mode = false
var location=[]

onready var sign_on_screen=$SignArea/Sign
onready var scale = $SignArea/Sign.rect_scale.x
export var move_speed = 0.5 


var move_speed_max=1000
var move_speed_acceleration=500
var temporary_move_speed=0
var direction=1
var acclelertion_mode=0
var temporary_word_lenght=0
var temporary_border=0

func _ready():
	visible=false
	bb_initial_set()
	bb_disable_buttons(true)
	set_process(false)
	pass # Replace with function body.

func _process(delta):
	bb_check_border()
	match acclelertion_mode:
		0:
			bb_move_with_acceleration(delta)
		1:
			bb_move_and_slow_down(delta)


func bb_initial_set():
	on_screen = "A"
	get_node("Tile/A").visible = true
	get_node("Tile/B").visible = false
	get_node("Tile/C").visible = false
	meaning = ""
	woirdo = ""
	sign_on_screen.read_sign("")
	sign_on_screen.rect_position.x=-1122

func bb_update_sign(word):
	sign_on_screen.read_sign(word)


func bb_add_letter(letter,language="NONE",kind=0):
	if letter == "[":
		letter="["+language+str(kind)+"]"
	if  bb_check_if_length_is_valid():
		match on_screen:
			"A":
				woirdo += letter
				sign_on_screen.read_sign(woirdo)
				bb_check_if_answer_has_to_be_moved(woirdo)
			"B":
				meaning += letter
				sign_on_screen.read_sign(meaning)
				bb_check_if_answer_has_to_be_moved(meaning)



func bb_change_word_mode(d,m,y,nr):
	change_word_mode = true
	var source = Content.get("content")
	var words = source[y][m][d][nr]
	on_screen = "A"
	woirdo=words[0]
	location=[y,m,d,nr]
	meaning=words[1]
	sign_on_screen.read_sign(woirdo)


func bb_check_if_answer_has_to_be_moved(word):
	var length=scale*letter_size*LettersAndNumbers.bb_length(word)
	var border=-(length-576)/2-100
	if length>576:
		$ScreenTween.stop($SignArea,"rect_position:x")
		bb_start_answer_tween(border)
	else:
		if $SignArea.rect_position.x!=0:
			$ScreenTween.stop($SignArea,"rect_position:x")
			bb_start_answer_tween_mvoe_to0()

func bb_start_answer_tween(place):
	$ScreenTween.interpolate_property($SignArea,"rect_position:x",
		$SignArea.rect_position.x,place,move_speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$ScreenTween.start()

func bb_start_answer_tween_mvoe_to0():
	$ScreenTween.interpolate_property($SignArea,"rect_position:x",
		$SignArea.rect_position.x,0,move_speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$ScreenTween.start()

func bb_stop_tween():
	$ScreenTween.stop($SignArea,"rect_position:x")
	$SignArea.rect_position=Vector2.ZERO


func bb_remove_last_letter():
	var removing_foreign=false
	match on_screen:
		"A":
			if not LettersAndNumbers.bb_length(woirdo)==0:
				if woirdo[woirdo.length()-1]=="]":
					removing_foreign=true
					while removing_foreign:
						if woirdo[woirdo.length()-1]=="[":
							removing_foreign=false
						woirdo.erase(woirdo.length()-1, 1)
				else:
					woirdo.erase(woirdo.length()-1, 1)
				sign_on_screen.read_sign(woirdo)
				bb_check_if_answer_has_to_be_moved(woirdo)
		"B":
			if not LettersAndNumbers.bb_length(meaning)==0:
				if meaning[meaning.length()-1]=="]":
					removing_foreign=true
					while removing_foreign:
						if meaning[meaning.length()-1]=="[":
							removing_foreign=false
						meaning.erase(meaning.length()-1, 1)
				else:
					meaning.erase(meaning.length()-1, 1)
				sign_on_screen.read_sign(meaning)
				bb_check_if_answer_has_to_be_moved(meaning)



func bb_check_border():
	match direction:
		1:
			if temporary_border >=0:
				if sign_on_screen.rect_position.x>=-1122+temporary_border-50:
					set_process(false)
			else:
				if sign_on_screen.rect_position.x>=-1122-temporary_border+50:
					set_process(false)
		-1:
			if temporary_border >=0:
				if sign_on_screen.rect_position.x<=-1122-temporary_border+50:
					set_process(false)
			else:
				if sign_on_screen.rect_position.x<=-1122+temporary_border-50:
					set_process(false)



func bb_check_if_length_is_valid():
	var word_on_screen
	match on_screen:
		"A":
			word_on_screen=woirdo
		"B":
			word_on_screen=meaning
	temporary_word_lenght = letter_size * (LettersAndNumbers.bb_length(word_on_screen)+1)

	temporary_border = -(temporary_word_lenght*0.4 - 576)/2
	if temporary_word_lenght > sign_on_screen.rect_size.x or LettersAndNumbers.bb_length(word_on_screen)>(43):
		return false
	else:
		return true

func bb_disable_buttons(value):
	get_node("Confirm").disabled=value
	get_node("Back").disabled=value

func bb_pause_and_show_warning(d,m,y):
	Signals.emit_signal("show_warning5",d,m,y)
	

func _on_Confirm_button_down():
	but_pressed=true
	get_node(ScreenTween).bb_animate_pressing_button(100)
func _on_Confirm_button_up():
	if but_pressed:
		but_pressed=false
		get_node(ScreenTween).bb_animatation_stopped(100)
		match on_screen:
			"A":
				bb_stop_tween()
				on_screen = "B"
				sign_on_screen.read_sign(meaning)
				bb_check_if_answer_has_to_be_moved(meaning)
				get_node("Tile/A").visible = false
				get_node("Tile/B").visible = true
				sign_on_screen.rect_position.x=-1122
				set_process(false)
			"B":
				bb_stop_tween()
				if LettersAndNumbers.bb_length(woirdo)==0 or LettersAndNumbers.bb_length(meaning)==0:
					match change_word_mode:
						false:
							Signals.emit_signal("show_warning1")
						true:
							Signals.emit_signal("show_warning2")
					return

				bb_errase_unnecessary_spaces()
				var check = Content.check_is_dou_already_in_memory([woirdo,meaning],change_word_mode,location)
				if check[0]:
					bb_pause_and_show_warning(check[1],check[2],check[3])
				else:
					bb_save_woirdo()



func bb_save_woirdo():
	get_node("Tile/A").visible = false
	get_node("Tile/B").visible = false
	get_node("Tile/C").visible = true
	bb_disable_buttons(true)
	match change_word_mode:
		false:
			get_node("../MainAnim").play("02_hide_screen_show_start")
			Signals.emit_signal("save_word",woirdo,meaning)
			yield(get_tree(),"idle_frame")
			yield(get_tree(),"idle_frame")
			Signals.emit_signal("save_content_on_hard_disk")
		true:
			get_node("../MainAnim").play("02_hide_screen_show_memory")
			Signals.emit_signal("correct_word",location,woirdo,meaning)
			yield(get_tree(),"idle_frame")
			yield(get_tree(),"idle_frame")
			Signals.emit_signal("save_content_on_hard_disk")
			change_word_mode = false


func bb_errase_unnecessary_spaces():
	var first_letter_checked=false
	var space_in_middle_noted=false
	var better_woirdo=""
	var better_meaning=""
	for i in woirdo.length():
		if not first_letter_checked:
			if woirdo[i]==" ":
				pass
			else:
				first_letter_checked=true
				better_woirdo+=woirdo[i]
		else:
			if not woirdo[i]==" ":
				better_woirdo+=woirdo[i]
				space_in_middle_noted=false
			elif woirdo[i]==" " and space_in_middle_noted:
				pass
			else:
				space_in_middle_noted=true
				better_woirdo+=woirdo[i]
	if better_woirdo[better_woirdo.length()-1]==" ":
		better_woirdo.erase(better_woirdo.length()-1,1)
	
	first_letter_checked=false
	space_in_middle_noted=false
	for i in meaning.length():
		if not first_letter_checked:
			if meaning[i]==" ":
				pass
			else:
				first_letter_checked=true
				better_meaning+=meaning[i]
		else:
			if not meaning[i]==" ":
				better_meaning+=meaning[i]
				space_in_middle_noted=false
			elif meaning[i]==" " and space_in_middle_noted:
				pass
			else:
				space_in_middle_noted=true
				better_meaning+=meaning[i]
	if better_meaning[better_meaning.length()-1]==" ":
		better_meaning.erase(better_meaning.length()-1,1)

	meaning=better_meaning
	woirdo=better_woirdo


# warning-ignore:unused_argument
func _on_Confirm_toggled(button_pressed):
	pass # Replace with function body.


func _on_Back_button_down():
	but_pressed=true
	get_node(ScreenTween).bb_animate_pressing_button(101)
func _on_Back_button_up():
	if but_pressed:
		but_pressed=false
		get_node(ScreenTween).bb_animatation_stopped(101)
		match on_screen:
			"A":
				bb_stop_tween()
				bb_disable_buttons(true)
				match change_word_mode:
					false:
						get_node("../MainAnim").play("02_hide_screen_show_start")
					true:
						get_node("../MainAnim").play("02_hide_screen_show_memory")
						change_word_mode = false
			"B":
				bb_stop_tween()
				on_screen = "A"
				get_node("Tile/A").visible = true
				get_node("Tile/B").visible = false
				sign_on_screen.read_sign(woirdo)
				bb_check_if_answer_has_to_be_moved(woirdo)
				sign_on_screen.rect_position.x=-1122
				set_process(false)

func _on_Back_toggled(button_pressed):
	pass # Replace with function body.



func bb_move_with_acceleration(delta):
	if temporary_move_speed<=move_speed_max:
		temporary_move_speed += delta*move_speed_acceleration
	sign_on_screen.rect_position.x+=direction*temporary_move_speed*delta

func bb_move_and_slow_down(delta):
	if not temporary_move_speed<=0:
		temporary_move_speed -= delta*move_speed_acceleration
	else:
		set_process(false)
	sign_on_screen.rect_position.x+=direction*temporary_move_speed*delta

func bb_reset_proces():
	set_process(false)
	acclelertion_mode=0
	temporary_move_speed=0

func _on_MoveLeft_button_down():
	bb_reset_proces()
	direction=-1
	set_process(true)
func _on_MoveLeft_button_up():
	acclelertion_mode=1
func _on_MoveLeft_toggled(button_pressed):
	pass # Replace with function body.

func _on_MoveRight_button_down():
	bb_reset_proces()
	direction=+1
	set_process(true)
func _on_MoveRight_button_up():
	acclelertion_mode=1
func _on_MoveRight_toggled(button_pressed):
	pass # Replace with function body.
