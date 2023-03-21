extends Control

onready var Elements = $Elements.get_children()
onready var wordlist_on_screen = $Elements

export(NodePath) var MoveListTween
var moveListTween
var but_pressed=false

var glooming_wrong_answers=[]
var tween_speed = 1
var tween_dir = 0

#Variables for moving wordlins
var move_speed_max=1000
var move_speed_acceleration=2000
var temporary_move_speed=0
var direction=1
var acclelertion_mode=0
var temporary_borders=[0,0,0,0] #[left,right,top,down]
var temporary_word_lenght=0
var temporary_border=0
export var letter_size=156
onready var scale=$Elements.get_child(0).rect_scale.x

func _ready():
	moveListTween=get_node(MoveListTween)
	visible=false
	set_process(false)


func _process(delta):
	match acclelertion_mode:
		0:
			pass
		1:
			bb_check_border1()
			bb_move_v_with_acceleration(delta)
		2:
			bb_check_border1()
			bb_move_v_and_slow_down(delta)
		3:
			bb_check_border2()
			bb_move_h_with_acceleration(delta)
		4:
			bb_check_border2()
			bb_move_h_and_slow_down(delta)

func bb_print_score(score):
	$Sign2.read_sign(str(score)+"%")

func bb_print_answers(quests=[],answers=[],asnwers_effect=[]):
	var nr_of_letters=0
	var nr_of_answers=0
	for i in quests.size():
		nr_of_answers+=1
		Elements[i*2].visible=true
		var sign_1=quests[i][0]+"-"+quests[i][1]
		if LettersAndNumbers.bb_length(sign_1)>nr_of_letters:
			nr_of_letters=LettersAndNumbers.bb_length(sign_1)
		Elements[i*2].read_sign(sign_1)
		Elements[i*2+1].visible=true
		var sign_2=answers[i][0]+"-"+answers[i][1]
		if LettersAndNumbers.bb_length(sign_2)>nr_of_letters:
			nr_of_letters=LettersAndNumbers.bb_length(sign_2)
		Elements[i*2+1].read_sign(sign_2)
		if asnwers_effect[i]==0:
			var wrong_ans=$Elements.get_child(i*2+1)
			glooming_wrong_answers.append(wrong_ans)
	bb_show_incorect_answers()
	bb_check_if_move_buttons_are_required(nr_of_letters,nr_of_answers)

func bb_show_incorect_answers():
	for answer in glooming_wrong_answers:
		$ScoreTween.interpolate_property(answer,"modulate",
			answer.modulate,Color(1,tween_dir,tween_dir,1),tween_speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$ScoreTween.start()
	tween_dir=(tween_dir+1)%2

func _on_ScoreTween_tween_all_completed():
	for answer in glooming_wrong_answers:
		$ScoreTween.interpolate_property(answer,"modulate",
			answer.modulate,Color(1,tween_dir,tween_dir,1),tween_speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$ScoreTween.start()
	tween_dir=(tween_dir+1)%2










func bb_check_if_move_buttons_are_required(l_nr,a_nr):
	if a_nr>4:
		$MoveWordUD.visible=true
		temporary_borders[3]=-(a_nr-4)*200
		temporary_borders[2]=0
	if letter_size*l_nr*scale>576:
		$MoveWordLR.visible=true
		temporary_borders[0]=-(letter_size*l_nr*scale-576)/2
		temporary_borders[1]=(letter_size*l_nr*scale-576)/2

func bb_reset_scores():
	wordlist_on_screen.rect_position=Vector2(0,0)
	for i in Elements.size():
		Elements[i].visible=false
	for answer in glooming_wrong_answers:
		answer.modulate=Color(1,1,1,1)
	$ScoreTween.remove_all()
	glooming_wrong_answers=[]
	tween_dir=0
	$MoveWordLR.visible=false
	$MoveWordUD.visible=false

func _on_Back_button_down():
	get_parent().challangetween.bb_animate_pressing_button(8)
func _on_Back_button_up():
	get_parent().challangetween.bb_animatation_stopped(8)
	get_node("../../MainAnim").play("04_hide_chalange_show_start")
func _on_Back_toggled(button_pressed):
	pass # Replace with function body.




func bb_reset_proces():
	set_process(false)
	acclelertion_mode=0
	temporary_move_speed=0

func bb_check_border1():
	var right = temporary_borders[1]
	var left = temporary_borders[0]
	match direction:
		1:
			if (wordlist_on_screen.rect_position.x)>=right:
				set_process(false)
		-1:
			if (wordlist_on_screen.rect_position.x)<=left:
				set_process(false)


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



func bb_move_v_with_acceleration(delta):
	if temporary_move_speed<=move_speed_max:
		temporary_move_speed += delta*move_speed_acceleration
	wordlist_on_screen.rect_position.x+=direction*temporary_move_speed*delta

func bb_move_v_and_slow_down(delta):
	if not temporary_move_speed<=0:
		temporary_move_speed -= delta*move_speed_acceleration
	else:
		set_process(false)
	wordlist_on_screen.rect_position.x+=direction*temporary_move_speed*delta

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


func _on_MoveWordlistRight_button_down():
	moveListTween.bb_animate_pressing_button(8)
	but_pressed=true
	bb_reset_proces()
	direction=-1
	acclelertion_mode=1
	set_process(true)
func _on_MoveWordlistRight_button_up():
	if but_pressed:
		moveListTween.bb_animatation_stopped(8)
		but_pressed=false
		acclelertion_mode=2
func _on_MoveWordlistRight_toggled(button_pressed):
	pass # Replace with function body.


func _on_MoveWordlistLeft_button_down():
	moveListTween.bb_animate_pressing_button(7)
	but_pressed=true
	bb_reset_proces()
	direction=1
	acclelertion_mode=1
	set_process(true)
func _on_MoveWordlistLeft_button_up():
	if but_pressed:
		moveListTween.bb_animatation_stopped(7)
		but_pressed=false
		acclelertion_mode=2
func _on_MoveWordlistLeft_toggled(button_pressed):
	pass # Replace with function body.


func _on_MoveWordlistUP_button_down():
	moveListTween.bb_animate_pressing_button(5)
	but_pressed=true
	bb_reset_proces()
	direction=1
	acclelertion_mode=3
	set_process(true)
func _on_MoveWordlistUP_button_up():
	if but_pressed:
		moveListTween.bb_animatation_stopped(5)
		but_pressed=false
		acclelertion_mode=4
func _on_MoveWordlistUP_toggled(button_pressed):
	pass # Replace with function body.


func _on_MoveWordlistDOWN_button_down():
	moveListTween.bb_animate_pressing_button(6)
	but_pressed=true
	bb_reset_proces()
	direction=-1
	acclelertion_mode=3
	set_process(true)
func _on_MoveWordlistDOWN_button_up():
	if but_pressed:
		moveListTween.bb_animatation_stopped(6)
		but_pressed=false
		acclelertion_mode=4
func _on_MoveWordlistDOWN_toggled(button_pressed):
	pass # Replace with function body.








