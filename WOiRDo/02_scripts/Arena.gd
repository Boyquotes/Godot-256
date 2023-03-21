extends Control

export(NodePath) var keyboard
export(NodePath) var spec_keyboard


var questions = []
var saved_answers = []
var saved_answers_effect = []
var answer = ""
var on_screen = 0
var word_or_meaning = 1
var succeses=0
var failes=0
export var time_for_one_letter = 3.0
var time_start_pos=Vector2(322,0)
var type_of_arena=0

var final_anim=false
var checking_answer=false
var button_ready=false


var temporary_word_lenght
var letter_size = 156
export var move_speed = 2 # time w [s]
export var answer_move_speed = 0.5
var quest_move_dir = 1
onready var quest_scale=$Quest.get_child(0).rect_scale.x
onready var answer_scale=$Answer.get_child(0).rect_scale.x
var temporary_border

func _ready():
	pass # Replace with function body.

func bb_start_quest():
	bb_show_question(on_screen)
	$CatReady.playing=true
	$Rat.set_animation("Idle")
	$Rat.playing=true

func bb_restart_elements():
	saved_answers = []
	saved_answers_effect = []
	succeses=0
	failes=0
	quest_move_dir=1
	answer = ""
	get_node("Quest/Sign").read_sign("")
	on_screen = 0
	$Answer/Sign.read_sign(answer)
	$Progress/Time.rect_position=time_start_pos
	$Explosion.visible=false
	$Explosion.scale=Vector2(0.2,0.2)
	button_ready=false

func bb_stop_q_and_a_tweens():
	$Quest/QuestTween.remove_all()
	$Answer/AnswerTween.remove_all()
	$Quest.rect_position=Vector2.ZERO
	$Answer.rect_position=Vector2.ZERO



func bb_draw_words(base,mode):
	var old_array=base
	var new_array=[]
	for i in mode:
		randomize()
		var rand_nr = randi() % old_array.size()
		new_array.append(old_array[rand_nr])
		old_array.remove(rand_nr)
	questions=new_array

func bb_start_time(length):
	var time=time_for_one_letter*length
	$Tween.interpolate_property($Progress/Time,"rect_position",time_start_pos,Vector2(0,0),time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree(), "idle_frame")
	$Explosion.visible=false
	$Explosion.scale=Vector2(0.2,0.2)

func _on_Tween_tween_completed(object, key):
	if final_anim:
		bb_show_question(on_screen)
		final_anim=false
		checking_answer=false
		return
	bb_show_final_anim(bb_check_if_answer_is_correct())
func bb_show_final_anim(value):
	button_ready=false
	final_anim=true
	match value:
		true:
				$Tween.interpolate_property($Progress/Time,"rect_position",
				$Progress/Time.rect_position,Vector2($Progress/Time.rect_position.x,500),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
		false:
				$Explosion.visible=true
				$Tween.interpolate_property($Explosion,"scale",
				Vector2(0.2,0.2),Vector2(1.2,1.2),1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()


func bb_anim_for_final_answer():
	var time=$Progress/Time.rect_position.x/time_start_pos.x
	$Tween.remove_all()
	$Tween.interpolate_property($Progress/Time,"rect_position",$Progress/Time.rect_position,Vector2(0,0),time,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()



func bb_show_question(nr):

	if on_screen == questions.size():
		bb_stop_q_and_a_tweens()
		bb_end_challenge_and_show_score()
	else:
		bb_show_anim()
		get_node(keyboard).bb_shufle_key_placement()
		$Tween.remove_all()
		bb_stop_q_and_a_tweens()
		answer = ""
		$Answer/Sign.read_sign(answer)
		word_or_meaning = bb_draw_word_or_meaning()
		bb_print_quest(questions[nr][word_or_meaning])
		bb_start_time(LettersAndNumbers.bb_length(questions[nr][(word_or_meaning+1)%2]))
		button_ready=true
	on_screen += 1

func bb_show_anim():
	$Rat.frame=0
	$Rat.set_animation("Fire")


func bb_print_quest(word):
	get_node("Quest/Sign").read_sign(word)
	var length=quest_scale*letter_size*LettersAndNumbers.bb_length(word)
	if length>576:
		bb_start_quest_tween(word,length)


func bb_start_quest_tween(word,length):
	var new_pos=(576-length-50)/2*quest_move_dir
	quest_word = word
	quest_length = length 
	$Quest/QuestTween.interpolate_property($Quest,"rect_position:x",
		$Quest.rect_position.x,new_pos,move_speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Quest/QuestTween.start()
	quest_move_dir*=-1

var quest_word = ""
var quest_length = 0

func _on_QuestTween_tween_completed(object, key):
	bb_start_quest_tween(quest_word,quest_length)


func bb_save_answer():
	saved_answers.append([])
	var nr_of_duo = on_screen-1
	match word_or_meaning:
		0:
			saved_answers[nr_of_duo].append(questions[nr_of_duo][0])
			saved_answers[nr_of_duo].append(answer)
		1:
			saved_answers[nr_of_duo].append(answer)
			saved_answers[nr_of_duo].append(questions[nr_of_duo][1])

func bb_end_challenge_and_show_score():
	var score=round(float(succeses)/float(on_screen)*100)
	get_node("../Score").bb_print_score(score)
	get_node("../Score").bb_print_answers(questions,saved_answers,saved_answers_effect)
	$Tween.remove_all()
	$CatReady.playing=false
	Content.achivements[type_of_arena*2]+=score
	Content.achivements[type_of_arena*2+1]+=1
	Signals.emit_signal("save_content_on_hard_disk")
	get_node("../../MainAnim").play("07_hide_arena_show_score")


func bb_reset_keyboards():
	get_node(keyboard).get_node(get_node(keyboard).keyboardtween).bb_reset_tween()
	get_node(spec_keyboard).get_node(get_node(spec_keyboard).specialkeyboardtween).bb_reset_tween()



func bb_draw_word_or_meaning():
	randomize()
	var nr=randi()%2
	return nr



func bb_check_if_answer_is_correct():

	get_node("../Effects").bb_reset()
	bb_save_answer()
	if answer==questions[on_screen-1][(word_or_meaning+1)%2]:
		get_node("../Effects").bb_show_success()
		succeses+=1
		saved_answers_effect.append(1)
		return true
	else:
		get_node("../Effects").bb_show_fail()
		failes+=1
		saved_answers_effect.append(0)
		return false
		

func _on_Next_button_down():
	get_parent().but_pressed=true
	get_parent().challangetween.bb_animate_pressing_button(7)
func _on_Next_button_up():
	if get_parent().but_pressed:
		get_parent().challangetween.bb_animatation_stopped(7)
		get_parent().but_pressed=false
		if button_ready:
				button_ready=false
				if not checking_answer:
					checking_answer=true
					bb_anim_for_final_answer()
func _on_Next_toggled(button_pressed):
	pass # Replace with function body.


func bb_add_letter_in_quest(letter,language="NONE",kind=0):
	if letter == "[":
		letter="["+language+str(kind)+"]"
	if  bb_check_if_length_is_valid():
		answer += letter
		bb_check_if_answer_has_to_be_moved(answer)
		$Answer/Sign.read_sign(answer)

func bb_check_if_answer_has_to_be_moved(word):
	var length=answer_scale*letter_size*LettersAndNumbers.bb_length(word)
	var border=-(length-576)/2-100
	if length>550:
		$Answer/AnswerTween.remove_all()
		bb_start_answer_tween(border)
	else:
		if $Answer.rect_position.x!=0:
			$Answer/AnswerTween.remove_all()
			bb_start_answer_tween_mvoe_to0()
			pass


func bb_start_answer_tween(place):
	$Answer/AnswerTween.interpolate_property($Answer,"rect_position:x",
		$Answer.rect_position.x,place,answer_move_speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Answer/AnswerTween.start()

func bb_start_answer_tween_mvoe_to0():
	$Answer/AnswerTween.interpolate_property($Answer,"rect_position:x",
		$Answer.rect_position.x,0,answer_move_speed,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Answer/AnswerTween.start()

func bb_remove_last_letter_in_quest():
	var removing_foreign=false
	if not answer.length()==0:

		if answer[answer.length()-1]=="]":
			removing_foreign=true
			while removing_foreign:
				if answer[answer.length()-1]=="[":
					removing_foreign=false
				answer.erase(answer.length()-1, 1)
		else:
			answer.erase(answer.length()-1, 1)

		bb_check_if_answer_has_to_be_moved(answer)
		$Answer/Sign.read_sign(answer)




func bb_check_if_length_is_valid():
	var word_on_screen = answer
	temporary_word_lenght = letter_size * (LettersAndNumbers.bb_length(word_on_screen)+1)
	temporary_border = -(temporary_word_lenght*0.4 - 576)/2
	if temporary_word_lenght > $Answer/Sign.rect_size.x or LettersAndNumbers.bb_length(word_on_screen)>(43):
		return false
	else:
		return true



func _on_Rat_animation_finished():
	if $Rat.animation=="Fire":
		$Rat.set_animation("Idle")
