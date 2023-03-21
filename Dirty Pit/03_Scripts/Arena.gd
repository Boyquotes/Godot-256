extends Node2D

var time_long_of_your_turn = 20
var time_before_start_fight = 1
var wait_time_for_button = 1
var wait_time_for_watchagain_button = 0.5
var wait_time_for_correct_button = 1.5
var active_label = LABELS.Empty setget set_active_label

var time_elapsed_for_your_turn 

var question_board_mode = QUESTIONBOARD.UP setget set_question_board_mode
var ready_board_mode = READYBOARD.UP setget set_ready_board_mode
var correct_board_mode = CORRECTBOARD.UP setget set_correct_board_mode
var watchagain_board_mode = WATCHAGAINBOARD.UP setget set_watchagain_board_mode


onready var global_tween = $GlobTween
onready var play_tween = $TopButtons/PlayBoard/PlayTween
onready var ready_tween = $TopButtons/ReadyBoard/ReadyTween
onready var correct_tween = $TopButtons/CorrectBoard/CorrectTween
onready var watchagain_tween = $TopButtons/WatchAgainBoard/WatchAgainTween
onready var question_tween = $TopButtons/QuestionBoard/QuestionTween

var play_but_start_pos = Vector2(700,-110)
var play_but_play_pos = Vector2(700,25)
var ready_but_start_pos = Vector2(30,-110)
var ready_but_play_pos = Vector2(30,80)
var correct_but_start_pos = Vector2(185,-110)
var correct_but_play_pos = Vector2(185,45)
var watchagain_but_start_pos = Vector2(600,-110)
var watchagain_but_play_pos = Vector2(600,35)
var question_but_start_pos = Vector2(310,-200)
var question_but_play_pos = Vector2(310,180)

enum QUESTIONBOARD {
	UP,
	MOVEUP,
	MOVEDOWN,
	DOWN
}

enum LABELS {
	Empty,
	YourTurn,
	YourTimeIsUp
	
}

enum READYBOARD {
	UP,
	MOVEUP,
	MOVEDOWN,
	DOWN
}

enum CORRECTBOARD {
	UP,
	MOVEUP,
	MOVEDOWN,
	DOWN
}

enum WATCHAGAINBOARD {
	UP,
	MOVEUP,
	MOVEDOWN,
	DOWN
}


func set_active_label(value):
	active_label = value
	for label in $Labels.get_children():
		label.visible = false
	$Labels.get_child(value).visible = true

func set_question_board_mode(value):
	question_board_mode = value

func set_ready_board_mode(value):
	ready_board_mode = value

func set_correct_board_mode(value):
	correct_board_mode = value

func set_watchagain_board_mode(value):
	watchagain_board_mode = value


func _ready():
	$Time.visible = false
	set_active_label(0)
	$FightIsGonnaStart.visible = false

	$TopButtons/PlayBoard.rect_position=play_but_start_pos
	$TopButtons/ReadyBoard.rect_position=ready_but_start_pos
	$TopButtons/CorrectBoard.rect_position=correct_but_start_pos
	$TopButtons/WatchAgainBoard.rect_position=watchagain_but_start_pos


func clear_arena():
	for label in $Labels.get_children():
		label.visible = false
	$Time.visible = false
	$Time/TextureProgress.value = 100
	$TopButtons/PlayBoard.rect_position=play_but_start_pos
	$TopButtons/ReadyBoard.rect_position=ready_but_start_pos
	$TopButtons/CorrectBoard.rect_position=correct_but_start_pos
	$TopButtons/WatchAgainBoard.rect_position=watchagain_but_start_pos




func start_your_turn():
	$Time/TimeTween.interpolate_property($Time/TextureProgress, "value",
100,0, time_long_of_your_turn,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Time/TimeTween.start()


func _on_TextureProgress_value_changed(value):
	if value == 0:
		GlobalSignals.emit_signal("_your_time_is_up")
		set_active_label(2)

func _on_FightStart_value_changed(value):
	if value == 0:
		GlobalSignals.emit_signal("_start_exchange_of_hits")
		set_active_label(4)


func stop_time():
	$Time/TimeTween.stop($Time/TextureProgress)
	$Time.visible = false
	time_elapsed_for_your_turn = $Time/TimeTween.tell()
#	$Time/TextureProgress.value = 100

func start_time_again():
	print($Time/TextureProgress.value)
	$Time/TimeTween.interpolate_property($Time/TextureProgress, "value",
$Time/TextureProgress.value,0, (time_long_of_your_turn-time_elapsed_for_your_turn),
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Time/TimeTween.start()
	$Time.visible = true
#	$Time/TextureProgress.value = 100


func few_sec_before_start():
	$FightIsGonnaStart/TweenFight.interpolate_property($FightIsGonnaStart/FightStart, "value",
100,0, time_before_start_fight,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FightIsGonnaStart/TweenFight.start()
	$FightIsGonnaStart.visible = true
	set_active_label(3)

func show_playboard():
	play_tween.interpolate_property($TopButtons/PlayBoard, "rect_position",
play_but_start_pos,play_but_play_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	play_tween.start()
	yield(play_tween,"tween_completed")
	$TopButtons/PlayBoard/Play.disabled = false
func hide_playboard():
	$TopButtons/PlayBoard/Play.disabled = true
	play_tween.interpolate_property($TopButtons/PlayBoard, "rect_position",
play_but_play_pos,play_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	play_tween.start()
	pass

func show_readyboard():
	ready_tween.interpolate_property($TopButtons/ReadyBoard, "rect_position",
ready_but_start_pos,ready_but_play_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	ready_tween.start()
func hide_readyboard():
	ready_tween.interpolate_property($TopButtons/ReadyBoard, "rect_position",
ready_but_play_pos,ready_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	ready_tween.start()


func show_correctboard():
	correct_tween.interpolate_property($TopButtons/CorrectBoard, "rect_position",
correct_but_start_pos,correct_but_play_pos, wait_time_for_correct_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	correct_tween.start()
func hide_correctboard():
	correct_tween.interpolate_property($TopButtons/CorrectBoard, "rect_position",
correct_but_play_pos,correct_but_start_pos, wait_time_for_correct_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	correct_tween.start()


func show_watchagainboard():
	watchagain_tween.interpolate_property($TopButtons/WatchAgainBoard, "rect_position",
watchagain_but_start_pos,watchagain_but_play_pos, wait_time_for_watchagain_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	watchagain_tween.start()
func hide_watchagainboard():
	watchagain_tween.interpolate_property($TopButtons/WatchAgainBoard, "rect_position",
watchagain_but_play_pos,watchagain_but_start_pos,wait_time_for_watchagain_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	watchagain_tween.start()


func show_questionboard():
	question_tween.interpolate_property($TopButtons/QuestionBoard, "rect_position",
question_but_start_pos,question_but_play_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	question_tween.start()
func hide_questionboard():
	question_tween.interpolate_property($TopButtons/QuestionBoard, "rect_position",
question_but_play_pos,question_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	question_tween.start()


func stop_boards_and_move_up():
	ready_tween.stop($TopButtons/ReadyBoard)
	correct_tween.stop($TopButtons/CorrectBoard)
	watchagain_tween.stop($TopButtons/WatchAgainBoard)
	question_tween.stop($TopButtons/QuestionBoard)
	ready_tween.interpolate_property($TopButtons/ReadyBoard, "rect_position",
$TopButtons/ReadyBoard.rect_position,ready_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	correct_tween.interpolate_property($TopButtons/CorrectBoard, "rect_position",
$TopButtons/CorrectBoard.rect_position,correct_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	watchagain_tween.interpolate_property($TopButtons/WatchAgainBoard, "rect_position",
$TopButtons/WatchAgainBoard.rect_position,watchagain_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	question_tween.interpolate_property($TopButtons/QuestionBoard, "rect_position",
$TopButtons/QuestionBoard.rect_position,question_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	set_question_board_mode(1)
	set_ready_board_mode(1)
	set_correct_board_mode(1)
	set_watchagain_board_mode(1)
	ready_tween.start()
	correct_tween.start()
	watchagain_tween.start()
	question_tween.start()

func stop_boards_and_move_down_question_up(): 
	ready_tween.stop($TopButtons/ReadyBoard)
	correct_tween.stop($TopButtons/CorrectBoard)
	watchagain_tween.stop($TopButtons/WatchAgainBoard)
	question_tween.stop($TopButtons/QuestionBoard)
	ready_tween.interpolate_property($TopButtons/ReadyBoard, "rect_position",
$TopButtons/ReadyBoard.rect_position,ready_but_play_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	correct_tween.interpolate_property($TopButtons/CorrectBoard, "rect_position",
$TopButtons/CorrectBoard.rect_position,correct_but_play_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	watchagain_tween.interpolate_property($TopButtons/WatchAgainBoard, "rect_position",
$TopButtons/WatchAgainBoard.rect_position,watchagain_but_play_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	question_tween.interpolate_property($TopButtons/QuestionBoard, "rect_position",
$TopButtons/QuestionBoard.rect_position,question_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	set_question_board_mode(1)
	set_ready_board_mode(2)
	set_correct_board_mode(2)
	set_watchagain_board_mode(2)
	ready_tween.start()
	correct_tween.start()
	watchagain_tween.start()
	question_tween.start()

func stop_boards_and_move_up_question_down():
	ready_tween.stop($TopButtons/ReadyBoard)
	correct_tween.stop($TopButtons/CorrectBoard)
	watchagain_tween.stop($TopButtons/WatchAgainBoard)
	question_tween.stop($TopButtons/QuestionBoard)
	ready_tween.interpolate_property($TopButtons/ReadyBoard, "rect_position",
$TopButtons/ReadyBoard.rect_position,ready_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	correct_tween.interpolate_property($TopButtons/CorrectBoard, "rect_position",
$TopButtons/CorrectBoard.rect_position,correct_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	watchagain_tween.interpolate_property($TopButtons/WatchAgainBoard, "rect_position",
$TopButtons/WatchAgainBoard.rect_position,watchagain_but_start_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	question_tween.interpolate_property($TopButtons/QuestionBoard, "rect_position",
$TopButtons/QuestionBoard.rect_position,question_but_play_pos, wait_time_for_button,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	set_question_board_mode(2)
	set_ready_board_mode(1)
	set_correct_board_mode(1)
	set_watchagain_board_mode(1)
	ready_tween.start()
	correct_tween.start()
	watchagain_tween.start()
	question_tween.start()


func _on_Play_button_down():
	pass # Replace with function body.
func _on_Play_button_up():
	GlobalSignals.emit_signal("_ready_to_see_opponent_combination")


func _on_CombinationReady_button_down():
	pass # Replace with function body.
func _on_CombinationReady_button_up():
	GlobalSignals.emit_signal("_your_comb_ready_before_times_up")


func _on_Correct_button_down():
	pass # Replace with function body.
func _on_Correct_button_up():
	GlobalSignals.emit_signal("_prepare_new_combination_for_hero")


func _on_WatchAgain_button_down():
	stop_boards_and_move_up_question_down()
	GlobalSignals.emit_signal("_arena_is_asking_a_question")
func _on_WatchAgain_button_up():
	pass # Replace with function body.


##### DO YOU WANT TO SEE AD? ###
func _on_YES_button_down():
	pass # Replace with function body.
func _on_YES_button_up():
	stop_time()
	hide_questionboard()
#	load_rewarded()
#	$ConectionChecker.emit_signal("make_request")
	GlobalSignals.emit_signal("_player_wants_to_watch_comb_again")


func _on_NO_button_down():
	pass # Replace with function body.
func _on_NO_button_up():
	stop_boards_and_move_down_question_up()
	yield(question_tween,"tween_completed")
	GlobalSignals.emit_signal("_arena_stopped_asking_a_question")



######################################
########  ADVERTISMENTS  #########
######################################
onready var admob = $AdMob
var can_receive_reward = false


func load_rewarded():
	admob.load_rewarded_video()


func _on_rewarded_video_loaded():
	admob.show_rewarded_video()


func connection_from_admob():
	admob.connect("rewarded_video_loaded",self,"_on_rewarded_video_loaded")
	admob.connect("rewarded_video_closed",self,"_on_rewarded_video_closed")
	admob.connect("rewarded",self,"_on_rewarded")


func _on_rewarded(_curr,_amount):
	can_receive_reward = true


func _on_rewarded_video_closed():
	if not can_receive_reward:
		set_active_label(7)
		show_questionboard()
		yield(get_parent().question_tween,"tween_completed")
		set_active_label(0)
		start_time_again()
	else:
		GlobalSignals.emit_signal("_player_wants_to_watch_comb_again")
		can_receive_reward = false
