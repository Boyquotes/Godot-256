extends CanvasLayer

onready var get_main_scene = get_tree().get_root().get_node("Main")

signal start_new_game
signal continue_old_game
signal show_options
signal show_saved_scores
signal help_onoff
signal tutorial_yesno
signal save_score
signal ask_for_save_confirmation
signal resign_from_saving
signal show_diffitulty_levels
signal back_to_main_menu
signal back_to_options
signal choose_difficulty
signal ask_for_confirmation_to_change_difficulty
signal resign_from_savedscores

enum {
	ASK_FOR_SAVE,
	ASK_FOR_DIFFICULTY_CHANGE
}

var difficulty_mode_to_implement = 0

var ask_mode = ASK_FOR_SAVE


func _ready():
#	$VBox/Continue.hide()
	connect("start_new_game",get_main_scene,"_start_new_game")
	connect("continue_old_game",get_main_scene,"_continue_old_game")
	connect("show_options",get_main_scene,"_show_options")
	connect("show_saved_scores",get_main_scene,"_show_saved_scores")
	connect("help_onoff",get_main_scene,"_show_help_onoff")
	connect("tutorial_yesno",get_main_scene,"_tutorial_yesno")
	connect("save_score",get_main_scene,"_save_score")
	connect("ask_for_save_confirmation",get_main_scene,"_show_confirmation_for_saving")
	connect("resign_from_saving",get_main_scene,"_resign_from_saving")
	connect("show_diffitulty_levels",get_main_scene,"_show_diffitulty_levels")
	connect("back_to_main_menu",get_main_scene,"_back_to_main_menu")
	connect("back_to_options",get_main_scene,"_back_to_options")
	connect("choose_difficulty",get_main_scene,"_choose_difficulty")
	connect("ask_for_confirmation_to_change_difficulty",get_main_scene,"_show_confirmation_for_changing_difficulty")
	connect("resign_from_savedscores",get_main_scene,"_on_resign_from_savedscores")


	connection_from_admob()

	pass # Replace with function body.

############# SIGNSALS FROM BUTTONS ##################

##############################
########  MAIN MENU  #########
##############################
func _on_StartGame_button_down():
	$VBox/StartGame.rect_position.y = 75
func _on_StartGame_button_up():
	$VBox/StartGame.rect_position.y = 0
func _on_StartGame_toggled(button_pressed):
	get_tree().paused = false
	emit_signal("start_new_game")

	$Label.set_text("PREPARE YOURSELF!")
	$Label.show()
	yield(get_tree().create_timer(3),"timeout")
	$Label.hide()
	pass # Replace with function body.

func _on_Continue_button_down():
	$VBox/Continue.rect_position.y = 75+171
func _on_Continue_button_up():
	$VBox/Continue.rect_position.y = 171
func _on_Continue_toggled(button_pressed):
	emit_signal("continue_old_game")

func _on_PlayTutorial_button_down():
	if $VBox/Continue.visible == true:
		$VBox/PlayTutorial.rect_position.y = 75+342
	else:
		$VBox/PlayTutorial.rect_position.y = 75+171
func _on_PlayTutorial_button_up():
	if $VBox/Continue.visible == true:
		$VBox/PlayTutorial.rect_position.y = 342
	else:
		$VBox/PlayTutorial.rect_position.y = 171
func _on_PlayTutorial_toggled(button_pressed):
	emit_signal("help_onoff")


func _on_Options_button_down():
	if $VBox/Continue.visible == true:
		$VBox/Options.rect_position.y = 75+513
	else:
		$VBox/Options.rect_position.y = 75+342
func _on_Options_button_up():
	if $VBox/Continue.visible == true:
		$VBox/Options.rect_position.y = 513
	else:
		$VBox/Options.rect_position.y = 342
func _on_Options_toggled(button_pressed):
	emit_signal("show_options")
	admob.load_banner()

func _on_EXIT_button_down():
	if $VBox/Continue.visible == true:
		$VBox/EXIT.rect_position.y = 75+684
	else:
		$VBox/EXIT.rect_position.y = 75+513
func _on_EXIT_button_up():
	if $VBox/Continue.visible == true:
		$VBox/EXIT.rect_position.y = 684
	else:
		$VBox/EXIT.rect_position.y = 513
func _on_EXIT_toggled(button_pressed):
	get_tree().quit()

##############################
########  SAVE BUTTON  #########
##############################

func _on_SaveScoreButton_button_down():
	$SaveScoreButton.rect_position.y = 605
func _on_SaveScoreButton_button_up():
	$SaveScoreButton.rect_position.y = 595
func _on_SaveScoreButton_toggled(button_pressed):
	emit_signal("ask_for_save_confirmation")
	ask_mode = ASK_FOR_SAVE
	pass # Replace with function body.

func _on_Yes_button_down():
	$VBoxConfirmation/Yes.rect_position.y = 75
func _on_Yes_button_up():
	$VBoxConfirmation/Yes.rect_position.y = 0
func _on_Yes_toggled(button_pressed):
	match ask_mode:
		ASK_FOR_SAVE:
			emit_signal("save_score")
			print("saved")
		ASK_FOR_DIFFICULTY_CHANGE:
			match difficulty_mode_to_implement:
				0:
					emit_signal("choose_difficulty","easy")
					emit_signal("back_to_options")
				1:
					emit_signal("choose_difficulty","medium")
					emit_signal("back_to_options")
				2:
					emit_signal("choose_difficulty","hard")
					emit_signal("back_to_options")

func _on_No_button_down():
	$VBoxConfirmation/No.rect_position.y = 260+75
func _on_No_button_up():
	$VBoxConfirmation/No.rect_position.y = 260
func _on_No_toggled(button_pressed):
	match ask_mode:
		ASK_FOR_SAVE:
			emit_signal("resign_from_saving")
		ASK_FOR_DIFFICULTY_CHANGE:
			emit_signal("back_to_options")
			$VBoxConfirmation.hide()
			$Label.hide()
			$Comment2.hide()

##############################
########  OPTIONS  #########
##############################

func _on_Difficulty_button_down():
	$VBoxOptions/Difficulty.rect_position.y = 75
func _on_Difficulty_button_up():
	$VBoxOptions/Difficulty.rect_position.y = 0
func _on_Difficulty_toggled(button_pressed):
	emit_signal("show_diffitulty_levels")


func _on_Sound_button_down():
		$VBoxOptions/Sound.rect_position.y = 75+171
func _on_Sound_button_up():
		$VBoxOptions/Sound.rect_position.y = 171
func _on_Sound_toggled(button_pressed):
	if get_main_scene.sound == false:
		get_main_scene.get_node("ThemeSong").stream_paused = false
		get_main_scene.sound = true
		get_main_scene.get_node("ThemeSong").play()
	else:
		get_main_scene.get_node("ThemeSong").stream_paused = true
		get_main_scene.sound = false
		get_main_scene.get_node("ThemeSong").stop()


func _on_SavedScores_button_down():
	$VBoxOptions/SavedScores.rect_position.y = 75+342
func _on_SavedScores_button_up():
	$VBoxOptions/SavedScores.rect_position.y = 342
func _on_SavedScores_toggled(button_pressed):
	$ConectionCheck.emit_signal("make_request")
	get_main_scene.hide_title()
	$VBoxOptions.hide()
	$Comment_4_Net.show()
#	emit_signal("show_saved_scores")

func _on_Back_button_down():
	$VBoxOptions/Back.rect_position.y = 75+513
func _on_Back_button_up():
	$VBoxOptions/Back.rect_position.y = 513
func _on_Back_toggled(button_pressed):
	admob.hide_banner()
	emit_signal("back_to_main_menu")

######################################
########  SAVED SCORES NET CHECK  #########
######################################

func _on_SavedScoresAgain_button_down():
	$VBoxSevedScores/SavedScoresAgain.rect_position.y = 75
func _on_SavedScoresAgain_button_up():
	$VBoxSevedScores/SavedScoresAgain.rect_position.y = 0
func _on_SavedScoresAgain_toggled(button_pressed):
	$VBoxSevedScores.hide()
	admob.hide_banner()
	$ConectionCheck.emit_signal("make_request")



func _on_BackFromSevedScores_button_down():
	$VBoxSevedScores/BackFromSevedScores.rect_position.y = 171 +75
func _on_BackFromSevedScores_button_up():
	$VBoxSevedScores/BackFromSevedScores.rect_position.y = 171
func _on_BackFromSevedScores_toggled(button_pressed):
	$ConectionCheck.emit_signal("resign_from_request")
	emit_signal("resign_from_savedscores")
	admob.show_banner()

######################################
########  DIFFICULTY LEVELS  #########
######################################

func _on_Easy_button_down():
	$VBoxDifficulty/Easy.rect_position.y = 75
func _on_Easy_button_up():
	$VBoxDifficulty/Easy.rect_position.y = 0
func _on_Easy_toggled(button_pressed):
	if get_main_scene.difficulty_mode == 0:
		emit_signal("back_to_options")
		print("you already have easy mode")
	else:
		match get_main_scene.just_started_new_game:
			true:
				difficulty_mode_to_implement = 0
				ask_mode = ASK_FOR_DIFFICULTY_CHANGE
				$VBoxDifficulty.hide()
				$VBoxConfirmation.show()
				$Label.set_text("ARE YOU SURE?")
				$Label.show()
				$Comment2.show()
			false:
				emit_signal("choose_difficulty","easy")
				emit_signal("back_to_options")

func _on_Medium_button_down():
	$VBoxDifficulty/Medium.rect_position.y = 75+186
func _on_Medium_button_up():
	$VBoxDifficulty/Medium.rect_position.y = 186
func _on_Medium_toggled(button_pressed):
	if get_main_scene.difficulty_mode == 1:
		emit_signal("back_to_options")
		print("you already have medium mode")
	else:
		match get_main_scene.just_started_new_game:
			true:
				difficulty_mode_to_implement = 1
				ask_mode = ASK_FOR_DIFFICULTY_CHANGE
				$VBoxDifficulty.hide()
				$VBoxConfirmation.show()
				$Label.set_text("ARE YOU SURE?")
				$Label.show()
				$Comment2.show()
			false:
				emit_signal("choose_difficulty","medium")
				emit_signal("back_to_options")

func _on_Hard_button_down():
	$VBoxDifficulty/Hard.rect_position.y = 75+372
func _on_Hard_button_up():
	$VBoxDifficulty/Hard.rect_position.y = 372
func _on_Hard_toggled(button_pressed):
	if get_main_scene.difficulty_mode == 2:
		emit_signal("back_to_options")
		print("you already have hard mode")
	else:
		match get_main_scene.just_started_new_game:
			true:
				difficulty_mode_to_implement = 2
				ask_mode = ASK_FOR_DIFFICULTY_CHANGE
				$VBoxDifficulty.hide()
				$VBoxConfirmation.show()
				$Label.set_text("ARE YOU SURE?")
				$Label.show()
				$Comment2.show()
			false:
				emit_signal("choose_difficulty","hard")
				emit_signal("back_to_options")


func _on_TutoYes_button_down():
	$VBoxConfirmTuto/TutoYes.rect_position.y = 10
func _on_TutoYes_button_up():
	$VBoxConfirmTuto/TutoYes.rect_position.y = 0
func _on_TutoYes_toggled(button_pressed):
	emit_signal("tutorial_yesno",true)


func _on_TutoNo_button_down():
	$VBoxConfirmTuto/TutoNo.rect_position.y = 270
func _on_TutoNo_button_up():
	$VBoxConfirmTuto/TutoNo.rect_position.y = 260
func _on_TutoNo_toggled(button_pressed):
	emit_signal("tutorial_yesno",false)

func enable_main_buttons():
	for button in $VBox.get_children():
		button.disabled = false
func disable_main_buttons():
	for button in $VBox.get_children():
		button.disabled = true

func enable_option_buttons():
	for button in $VBoxOptions.get_children():
		button.disabled = false
func disable_option_buttons():
	for button in $VBoxOptions.get_children():
		button.disabled = true

func enable_difficulty_buttons():
	for button in $VBoxDifficulty.get_children():
		button.disabled = false
func disable_difficulty_buttons():
	for button in $VBoxDifficulty.get_children():
		button.disabled = true

func enable_sevedscores_buttons():
	for button in $VBoxSevedScores.get_children():
		button.disabled = false
func disable_sevedscores_buttons():
	for button in $VBoxSevedScores.get_children():
		button.disabled = true


######################################
########  ADVERTISMENTS  #########
######################################
onready var admob = $AdMob
var can_receive_reward = false

func load_rewarded():
	$Comment_4_Net.text = "PLEASE, WAIT FOR A VIDEO"
	admob.hide_banner()
	admob.load_rewarded_video()

func _oo_rewarded_video_loaded():
	admob.show_rewarded_video()


func connection_from_admob():
	admob.connect("rewarded_video_loaded",self,"_oo_rewarded_video_loaded")
	admob.connect("rewarded_video_closed",self,"_on_rewarded_video_closed")
	admob.connect("rewarded",self,"_on_rewarded")

func _on_rewarded(curr,amount):
	can_receive_reward = true

func _on_rewarded_video_closed():
	if not can_receive_reward:
		$Comment_4_Net.text = "PLEASE, WATCH THE VIDEO TO THE END"
		$Comment_4_Net.show()
		$VBoxSevedScores.show()
	else:
		emit_signal("show_saved_scores")
		can_receive_reward = false



