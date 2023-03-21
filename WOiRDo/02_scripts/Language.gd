extends Control

export(NodePath) var MoveListTween
var moveListTween

var but_pressed=false

onready var wordlist_on_screen = $Languages

#Variables for moving wordlins
var move_speed_max=1000
var move_speed_acceleration=500
var temporary_move_speed=0
var direction=1
var acclelertion_mode=0
var temporary_borders=[0,0,0,-900] #[left,right,top,down]
var temporary_word_lenght=0
var temporary_border=0
export var letter_size=156
onready var scale=0.25

func _ready():
	moveListTween=get_node(MoveListTween)
	visible=false
	set_process(false)


func _process(delta):
	match acclelertion_mode:
		0:
			pass

		3:
			bb_check_border2()
			bb_move_h_with_acceleration(delta)
		4:
			bb_check_border2()
			bb_move_h_and_slow_down(delta)


func bb_reset_proces():
	set_process(false)
	acclelertion_mode=0
	temporary_move_speed=0



func bb_check_border2():
	var down = temporary_borders[3]
	var top = temporary_borders[2]
	match direction:
		1:
			if (wordlist_on_screen.rect_position.y)>=top:
				set_process(false)
		-1:
			if (wordlist_on_screen.rect_position.y)<=down:
				set_process(false)



func bb_move_h_with_acceleration(delta):
	if temporary_move_speed<=move_speed_max:
		temporary_move_speed += delta*move_speed_acceleration
	wordlist_on_screen.rect_position.y+=direction*temporary_move_speed*delta

func bb_move_h_and_slow_down(delta):
	if not temporary_move_speed<=0:
		temporary_move_speed -= delta*move_speed_acceleration
	else:
		set_process(false)
	wordlist_on_screen.rect_position.y+=direction*temporary_move_speed*delta


func _on_MoveWordlistUP_button_down():
	but_pressed=true
	moveListTween.bb_animate_pressing_button(9)
	bb_reset_proces()
	direction=1
	acclelertion_mode=3
	set_process(true)
func _on_MoveWordlistUP_button_up():
	if but_pressed:
		but_pressed=false
		acclelertion_mode=4
		moveListTween.bb_animatation_stopped(9)


func _on_MoveWordlistDOWN_button_down():
	but_pressed=true
	moveListTween.bb_animate_pressing_button(10)
	bb_reset_proces()
	direction=-1
	acclelertion_mode=3
	set_process(true)
func _on_MoveWordlistDOWN_button_up():
	if but_pressed:
		but_pressed=false
		acclelertion_mode=4
		moveListTween.bb_animatation_stopped(10)


