extends Node2D

#### AVAIBLE STATES ####
enum {
	YOU_ARE_ON_HUD,
	ANY_UNITS_NOT_SETECTED, 
	ADD_OR_REMOVE_SOME_UNITS,
	SOME_UNITS_SELECTED,
	SETTING_A_TARGET_TO_MOVE
}

enum DIFFICULTY {
	EASY,
	MEDIUM
	HARD
}

#### LOADED SCENES ####
var unit_package = preload("res://02_scenes/Unit.tscn")
var enemy_package = load("res://02_scenes/Enemy.tscn")

#### SOME VARIABLES ####
var state = YOU_ARE_ON_HUD setget set_state
var  difficulty_mode = DIFFICULTY.EASY
export var start_level = 1
export var max_number_of_units_in_the_box = 50
var selected_units = []
var sound = false
var final_score
var just_saved = false
var just_started_new_game = false setget set_just_started_new_game
#export var tutorial_active:bool = true


var max_number_of_units:int = 1
var killed_enemies:int = 0
var max_level:int = 1
# var enemy_spawner_time = 10

var save_vars = [
"dif_1","lev_1","kills_1",
"dif_2","lev_2","kills_2",
"dif_3","lev_3","kills_3",
"dif_4","lev_4","kills_4",
"dif_5","lev_5","kills_5",
"dif_6","lev_6","kills_6",
"dif_7","lev_7","kills_7",
"dif_8","lev_8","kills_8",
"dif_9","lev_9","kills_9",
"dif_10","lev_10","kills_10"
]


export(Script) var game_save_class

### SOME DICT ###
var avaible_units = {
	0:1,
	1:1,
	2:1
}

var units_in_battle = {
	0:0,
	1:0,
	2:0
}


signal number_of_avaible_units_changed

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#### SIGNALS FROM TUTORIAL ####
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

signal tuto_show_enemy
signal tuto_show_turtleys



func set_just_started_new_game(value):
	just_started_new_game = value
	if not just_started_new_game:
		$HUD/VBox/Continue.visible = false
		$HUD/SaveScoreButton.visible = false
		$HUD/Score.visible = false


func set_state(value):
	state = value

func _ready():
	_load_saved_score()
	#_hud_enemy_spawner()
	connect("number_of_avaible_units_changed",get_node("Interface"),"update_number")
	connect("tuto_show_enemy",self,"_tuto_show_enemy")
	connect("tuto_show_turtleys",self,"_tuto_show_turtleys")

func _on_MainTimer_timeout():
	print("START")
	$HUD/HUDAnim.play("Move Title")
	yield($HUD/HUDAnim,"animation_finished")
	$HUD/VBox.show()
	$HUD/HUDAnim.play("Move VBox IN")

func _input(event):
	match state:
		YOU_ARE_ON_HUD:
			pass
		ANY_UNITS_NOT_SETECTED:
			selected_units = RectSelection._rect_selection(event)
		SOME_UNITS_SELECTED:
			SettingTarget._target(event)
		SETTING_A_TARGET_TO_MOVE:
			SettingTarget._target(event)
	if event is InputEventKey:
		if event.scancode == KEY_M:
			if event.is_pressed():
#				print($Interface/Boxes/BoxFoUnits/Units.get_child_count())
#				print($Interface/Boxes/BoxFoUnits2/Units.get_child_count())
#				print($Interface/Boxes/BoxFoUnits3/Units.get_child_count())
				test_enemy_start()
				print("global mouse pos" + str(get_global_mouse_position()))
				SettingTarget.draging = false

func _process(delta):
	match state:
		YOU_ARE_ON_HUD:
			pass
		ANY_UNITS_NOT_SETECTED:
			pass
		SOME_UNITS_SELECTED:
			SettingTarget._target_process(delta)
			pass
		SETTING_A_TARGET_TO_MOVE:
			SettingTarget._target_process(delta)
			pass

func spawner_time_settings(value):
	var enemy_spawner_time = max((10 - value * 0.1),3)
	return enemy_spawner_time

func _start_new_game():
	$HUD/SaveScoreButton.hide()
	match just_started_new_game:
		false:
			$HUD/HUDAnim.play("Move VBox OUT ")
			yield($HUD/HUDAnim,"animation_finished")
			$HUD/HUDAnim.play_backwards("Move Title")
			print("is playing Move VBox OUT")
		true:
			$HUD/HUDAnim.play("Move VBox (ALL) OUT")
			print("is playing Move VBox (ALL) OUT")
	yield($HUD/HUDAnim,"animation_finished")
	$HUD/VBox.hide()
	$HUD/Title.hide()
	if $Interface/AnimPlayer.is_playing():
		yield($Interface/AnimPlayer,"animation_finished")

	$HUD/Score.hide()
	$HUD/SaveScoreButton.hide()
	wash_units_from_previous_game()
	wash_bubbles_from_previous_game()
	#yield(get_tree().create_timer(0.5),"timeout")
	if not $Enemies.get_children().empty():
		wash_enemies_from_previous_game()
		yield($Enemies,"no_enemies")
	wash_units_from_previous_game()

	yield(get_tree().create_timer(2),"timeout")
	just_started_new_game = true
	print("new game started")
	start_difficulty_level(start_level)
	_reset_number_of_avaible_units()
	_reset_number_of_units_in_battle()
	check_max_number_of_unit()

	$Interface/LevelNumber.set_text("Level " +str(DifficultyScaler.difficulty_level))
	final_score = 0
	killed_enemies = 0
	max_level= 1
	just_saved = false
	$ThemeSong.stream_paused = true
	set_state(ANY_UNITS_NOT_SETECTED)
	if sound:
		$BattleSong.play()
	yield(get_tree().create_timer(0.5),"timeout")
	show_in_game_interface()
	yield($Interface/AnimPlayer,"animation_finished")
	get_tree().paused = false
	_fill_the_boxes()
	$Interface.buttons_activate(true)
	_prepare_enemies_for_new_game()
	pass

func _game_over():
	set_just_started_new_game(false)
	$HUD/Label.set_text("YOU HAVE LOST")
	$HUD/Label.show()
#	if $Interface/AnimPlayer.is_playing():
#		yield($Interface/AnimPlayer,"animation_finished")
	$Interface.buttons_activate(false)
	$Interface.disabled_vacuum_and_pause_button()
	SettingTarget.draging = false
	SettingTarget.update()
#	get_tree().paused = true
	set_state(YOU_ARE_ON_HUD)

	wash_units_from_previous_game()
	wash_bubbles_from_previous_game()
	if not $Enemies.get_children().empty():
		wash_enemies_from_previous_game()
		yield($Enemies,"no_enemies")
	wash_units_from_previous_game()

	yield(get_tree().create_timer(2.2),"timeout")
	hide_in_game_interface()
	if $Interface/AnimPlayer.is_playing():
		yield($Interface/AnimPlayer,"animation_finished")
	_empty_the_boxes()

	_reset_number_of_avaible_units()
	yield(get_tree().create_timer(1),"timeout")
	$BattleSong.stop()
	if sound:
		$ThemeSong.stream_paused = false
	yield(get_tree().create_timer(1),"timeout")
	$HUD/Label.hide()
	$HUD/VBox.rect_position.y = 130
	match just_started_new_game:
		false:
			$HUD/HUDAnim.play("Move VBox IN")
		true:
			$HUD/HUDAnim.play("Move VBox (ALL) IN")
	$HUD/VBox.show()
	yield($HUD/HUDAnim,"animation_finished")

	score_details()
	$HUD/Score.show()
	if not just_saved:
		$HUD/SaveScoreButton.show()




##################################################
#################### TUTORIAL ####################
##################################################
func _show_help_onoff():
	$HUD/Score.visible = false
	$HUD/SaveScoreButton.visible = false
	match just_started_new_game:
		false:
			$HUD/HUDAnim.play("Move VBox OUT ")
		true:
			$HUD/HUDAnim.play("Move VBox (ALL) OUT")
	yield($HUD/HUDAnim,"animation_finished")
	$HUD/VBox.hide()
	$HUD/Comment3.show()
	$HUD/VBoxConfirmTuto.show()

func _tutorial_yesno(value:bool):
	$HUD/Comment3.hide()
	$HUD/VBoxConfirmTuto.hide()
	match value:
		true:
				$HUD/SaveScoreButton.visible = false
				$HUD/Score.visible = false
				$HUD/VBox/Continue.visible = false
				set_just_started_new_game(false)
				$HUD/VBox.rect_position.y = 130
				_play_in_tutorial()
		false:
			match just_started_new_game:
				false:
					$HUD/HUDAnim.play("Move VBox IN")
				true:
					$HUD/HUDAnim.play("Move VBox (ALL) IN")
			$HUD/VBox.show()
			if $HUD/HUDAnim.is_playing():
				yield($HUD/HUDAnim,"animation_finished")
			if just_started_new_game:
				$HUD/Score.visible = true
				$HUD/SaveScoreButton.visible = true



func _tuto_show_enemy(phase=0, mode=true, spawn_pos=Vector2(400,675)):
	$Background.tutorial_spawn_bubble(phase, mode, spawn_pos)


func _tuto_show_turtleys():
	for box in $Interface/Boxes.get_children():
		box.start_number_of_units(40)



func _play_in_tutorial():
	get_tree().paused = false
	wash_units_from_previous_game()
	wash_bubbles_from_previous_game()
	if not $Enemies.get_children().empty():
		wash_enemies_from_previous_game()
		yield($Enemies,"no_enemies")
	wash_units_from_previous_game()
	
	$HUD/HUDAnim.play_backwards("Move Title")
	$Interface.buttons_activate(false)
	$Interface.tutorial_mode = true
	$TUTORIAL/Plate/Background.show()
	show_in_tutorial_interface()
	for advice in $TUTORIAL/Plate/Background/Main.get_children():
		advice.hide()
	if $Interface/AnimPlayer.is_playing():
		yield($Interface/AnimPlayer,"animation_finished")

	_reset_number_of_avaible_units()
	_reset_number_of_units_in_battle()
	check_max_number_of_unit()

	$TUTORIAL.advice_nr0()
	$TUTORIAL.activate_tutorialbackbutton(true)

func _end_tuto():
	wash_units_from_previous_game()
	if not $Enemies.get_children().empty():
		wash_enemies_from_previous_game()
		yield($Enemies,"no_enemies")
	wash_units_from_previous_game()
	$TUTORIAL.hand.stop()
	$TUTORIAL.activate_tutorialbackbutton(false)
	$TUTORIAL.activate_tutorialnextbutton(false)

	$TUTORIAL.tutorial_step = 0
	$TUTORIAL/Plate/Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Interface.tutorial_mode = false
	$Interface.buttons_activate(false)
	hide_in_tutorial_interface()
	if $Interface/AnimPlayer.is_playing():
		yield($Interface/AnimPlayer,"animation_finished")

	$TUTORIAL/Plate/Background.hide()
	$TUTORIAL.hand.position = Vector2(240,400)
	$TUTORIAL.hand.frame = 0
	$TUTORIAL/Plate/Background/Main.rect_position = Vector2(20,72)
	
	$HUD/HUDAnim.play("Move Title")
	$HUD/Title.visible = true
	if $HUD/HUDAnim.is_playing():
		yield($HUD/HUDAnim,"animation_finished")
	
	
	match just_started_new_game:
		false:
			$HUD/HUDAnim.play("Move VBox IN")
		true:
			$HUD/HUDAnim.play("Move VBox (ALL) IN")
	
	$HUD/VBox.show()
	_empty_the_boxes()

##################################################
##################################################
##################################################

func _game_paused():
	$Interface.buttons_activate(false)

	get_tree().paused = true
	hide_in_game_interface()
	if $Interface/AnimPlayer.is_playing():
		yield($Interface/AnimPlayer,"animation_finished")
	
	$HUD/HUDAnim.play("Move VBox (ALL) IN")
	$HUD/VBox.show()
	$HUD/VBox/Continue.show()
	$HUD/VBox.rect_position.y = 20
	yield($HUD/HUDAnim,"animation_finished")


	score_details()
	$HUD/Score.show()
	if not just_saved:
		$HUD/SaveScoreButton.show()
	set_state(YOU_ARE_ON_HUD)
	#yield(get_tree().create_timer(1),"timeout")
#	get_tree().paused = true
	$BattleSong.stop()
	if sound:
		$ThemeSong.stream_paused = false
	pass

func _continue_old_game():
	$HUD/HUDAnim.play("Move VBox (ALL) OUT")
	yield($HUD/HUDAnim,"animation_finished")
	$HUD/VBox.hide()
	$HUD/Score.hide()
	$HUD/SaveScoreButton.hide()
	if $Interface/AnimPlayer.is_playing():
		yield($Interface/AnimPlayer,"animation_finished")
	$HUD/VBox.rect_position.y = 130
	show_in_game_interface()
	if $Interface/AnimPlayer.is_playing():
		yield($Interface/AnimPlayer,"animation_finished")
	get_tree().paused = false
	$Interface.buttons_activate(true)
	$ThemeSong.stream_paused = true
	if sound:
		$BattleSong.play()
	set_state(ANY_UNITS_NOT_SETECTED)

func score_details():
	$HUD/Score/MaxLevel.set_text("Your current level is: " +str(DifficultyScaler.difficulty_level))
	if killed_enemies == 1:
		$HUD/Score/KilledEnemies.set_text("You`ve killed " +str(killed_enemies) + " Enemy")
	else:
		$HUD/Score/KilledEnemies.set_text("You`ve killed " +str(killed_enemies) + " Enemies")
	match difficulty_mode:
		0:
			$HUD/Score/DifficultyMode.set_text("Difficulty: EASY")
		1:
			$HUD/Score/DifficultyMode.set_text("Difficulty: MEDIUM")
		2:
			$HUD/Score/DifficultyMode.set_text("Difficulty: HARD")
	#$HUD/Score/TotalScore.set_text("Your total score is: " +str(DifficultyScaler.difficulty_level*killed_enemies*(difficulty_mode+1)) )
	#final_score = DifficultyScaler.difficulty_level*killed_enemies*(difficulty_mode+1)

func _show_how_to_play():
	$ThemeSong.stream_paused = true
	if sound:
		$HelpSong.play()
		$HelpSong.autoplay = true
		$HelpSong.stream_paused = false
	$BattleSong.stop()
	$HELP/Plate.show()

func _show_options():
	$HUD/Score.hide()
	$HUD/SaveScoreButton.hide()
	match just_started_new_game:
		false:
			$HUD/HUDAnim.play("Move VBox OUT ")
		true:
			$HUD/HUDAnim.play("Move VBox (ALL) OUT")
	yield($HUD/HUDAnim,"animation_finished")
	$HUD/VBox.hide()
	$HUD/HUDAnim.play("Move VBoxOptions IN")
	$HUD/VBoxOptions.show()
	yield($HUD/HUDAnim,"animation_finished")


func _show_diffitulty_levels():
	$HUD/HUDAnim.play("Move VBoxOptions OUT")
	yield($HUD/HUDAnim,"animation_finished")
	$HUD/VBoxOptions.hide()
	$HUD/HUDAnim.play("VboxDifficulty IN")
	$HUD/VBoxDifficulty.show()

func _back_to_main_menu():
	$HUD/HUDAnim.play("Move VBoxOptions OUT")
	yield($HUD/HUDAnim,"animation_finished")
	if not $HUD/VBox/Continue.visible and not $HUD/Title.rect_position.y ==0:
		$HUD/HUDAnim.play("Move Title")
		yield($HUD/HUDAnim,"animation_finished")
	match just_started_new_game:
		false:
			$HUD/HUDAnim.play("Move VBox IN")
		true:
			$HUD/HUDAnim.play("Move VBox (ALL) IN")
	$HUD/VBox.show()
	yield($HUD/HUDAnim,"animation_finished")

	if just_started_new_game and not just_saved:
		$HUD/SaveScoreButton.show()
	if just_started_new_game:
		$HUD/Score.show()
	$HUD/VBoxOptions.hide()

func _back_to_options():
	$HUD/HUDAnim.play("VboxDifficulty OUT")
	yield($HUD/HUDAnim,"animation_finished")
	$HUD/VBoxDifficulty.hide()
	$HUD/HUDAnim.play("Move VBoxOptions IN")
	$HUD/VBoxOptions.show()

func _choose_difficulty(value):
	$HUD/VBoxConfirmation.hide()
	$HUD/Label.hide()
	$HUD/Comment2.hide()
	match value:
		"easy":
			difficulty_mode = DIFFICULTY.EASY
			print("easy mode activated")
		"medium":
			difficulty_mode = DIFFICULTY.MEDIUM
			print("medium mode activated")
		"hard":
			difficulty_mode = DIFFICULTY.HARD
			print("hard mode activated")
	set_just_started_new_game(false)
	$HUD/VBox.rect_position.y = 130
	$HUD/Title.show()

func _on_resign_from_savedscores():
	$HUD/VBoxSevedScores.hide()
	$HUD/Comment_4_Net.hide()
	$HUD/VBoxOptions.show()
	if not $HUD/VBox/Continue.visible and not $HUD/Title.rect_position.y ==0:
		$HUD/HUDAnim.play("Move Title")
		yield($HUD/HUDAnim,"animation_finished")
	$HUD/HUDAnim.play("Move VBoxOptions IN")

func hide_title():
	if not $HUD/VBox/Continue.visible and $HUD/Title.rect_position.y ==0:
		$HUD/HUDAnim.play_backwards("Move Title")
		print("dino")
		yield($HUD/HUDAnim,"animation_finished")

func _show_saved_scores():

	$HUD/VBoxOptions.hide()
	$ThemeSong.stream_paused = true
	if sound:
		$HelpSong.play()
		$HelpSong.autoplay = true
		$HelpSong.stream_paused = false
	$BattleSong.stop()
	$SAVEDSCORES/Plate.show()
	$SAVEDSCORES/VBoxContainer.show()
	$SAVEDSCORES/BackButton.show()

func _back_to_menu():
	$HUD.admob.load_banner()
	$HelpSong.stream_paused = true
	$HelpSong.stop()
	if sound:
		$ThemeSong.stream_paused = false
	$BattleSong.stop()
	$SAVEDSCORES/Plate.hide()
	$SAVEDSCORES/VBoxContainer.hide()
	$SAVEDSCORES/BackButton.hide()


	if not $HUD/VBox/Continue.visible and not $HUD/Title.rect_position.y ==0:
		$HUD/HUDAnim.play("Move Title")
		yield($HUD/HUDAnim,"animation_finished")
	$HUD/HUDAnim.play("Move VBoxOptions IN")
	$HUD/VBoxOptions.show()


func _fill_the_boxes():
	for box in $Interface/Boxes.get_children():
		box.start_number_of_units(avaible_units[box.kind_of_box])

func _empty_the_boxes():
	for box in $Interface/Boxes.get_children():
		box.clear_boxes()

func _reset_number_of_avaible_units():
	for i in range(3):
		avaible_units[i] = DifficultyScaler.difficulty_level
		emit_signal("number_of_avaible_units_changed",i)

func _reset_number_of_units_in_battle():
	for i in range(3):
		units_in_battle[i] = 0

func start_difficulty_level(level=1):
	DifficultyScaler.difficulty_level = - DifficultyScaler.get_difficulty_level()
	DifficultyScaler.difficulty_level = level
	DifficultyScaler.bottom_border = level
	DifficultyScaler.top_border = (level+1)

func wash_bubbles_from_previous_game():
	$Background/EnemySpawner.stop()
	if not $Background/Bubbles.get_children().empty():
		$Background.stop_spawning_bubbles()
	yield($Background,"bubbles_are_stopped")

func wash_enemies_from_previous_game():
	for enemy in $Enemies.get_children():
		enemy.washed_beacuse_of_new_game_started = true
	for enemy in $Enemies.get_children():
		match enemy.state_machine._current_state.name:
			"EatingState":
				wash_for_EatingState(enemy)
			"DieingState":
				wash_for_EatingState(enemy)
			"HittingBaseState":
				pass
			_:
				wash_for_AnyState(enemy)

func wash_for_EatingState(enemy):
	print("eating state")
	yield(enemy.state_machine,"state_changed")
	print("now is dieing")
	
	enemy.state_machine._current_state.get_node("Dieing").float_vel = Vector2(500,0)
	yield(enemy,"tree_exited")

func wash_for_DieingState(enemy):
	enemy.state_machine._current_state.get_node("Dieing").float_vel = Vector2(500,0)
	yield(enemy,"tree_exited")

func wash_for_AnyState(enemy):
	if enemy.waiting_for_attack.is_valid():
		enemy.waiting_for_attack.resume(10)
	enemy.set_linear_velocity(Vector2(0,-500))
	enemy.set_linear_damp(0)

func wash_units_from_previous_game():
	var in_battle_units = take_all_currently_in_battle_units()
	if not in_battle_units.empty():
		get_node("Background/Vacuum/Coll").position = Vector2(-180,560)
		for unit in in_battle_units:
			if not unit.state_machine._current_state.name=="EatedState":
				unit.state_machine.change_state_to("PrepareNewGameState")
		yield(get_tree().create_timer(2.1),"timeout")
		get_node("Background/Vacuum/Coll").position = Vector2(-400,560)


func _prepare_enemies_for_new_game():
	_in_game_enemy_spawner(1)
	$Background/EnemySpawner.set_one_shot(true)
	yield($Background/EnemySpawner,"timeout")
	_in_game_enemy_spawner(spawner_time_settings(DifficultyScaler.difficulty_level))



func _in_game_enemy_spawner(value):
	$Background/EnemySpawner.set_one_shot(false)
	$Background/EnemySpawner.set_wait_time(value)
	$Background/EnemySpawner.start()

func _hud_enemy_spawner():
	$Background/EnemySpawner.set_one_shot(false)
	$Background/EnemySpawner.set_wait_time(0.2)
	$Background/EnemySpawner.start()


func _spawn_unit(ID,pos,factor_1,tuto_mode=false):
	match ID:
		0:
			if avaible_units[0] >0:
				var blue_unit = unit_package.instance()
				var unit_in_box = get_node("Interface/Boxes/BoxFoUnits/Units").get_child((get_node("Interface/Boxes/BoxFoUnits/Units").get_child_count()-1))
				var box = $Interface/Boxes/BoxFoUnits
				if avaible_units[0]<=max_number_of_units_in_the_box:
					box.take_unit_out_of_box(unit_in_box)
				blue_unit.tutorial_mode = tuto_mode
				blue_unit.setup_start_position(transform.xform(unit_in_box.position))
				$Units/Blue.add_child(blue_unit)
#				blue_unit.unit_start_pos = transform.xform(unit_in_box.position)
				blue_unit.unit_in_front_of_box_pos = pos
				blue_unit.type_start_and_end_for_animation(blue_unit.unit_start_pos,blue_unit.unit_in_front_of_box_pos,ID,factor_1)
				blue_unit.get_node("Unit").modulate = Color(0.0,0.0,1.0,0.3)
				blue_unit.get_node("Mug").modulate = Color(0.63,0.4,0.4,0.3)
				blue_unit.set_kind_of_unit(0)
				#blue_unit.get_node("Body").set_collision_layer(16)
				blue_unit.get_node("Mouth").set_collision_layer(16)
				blue_unit.set_collision_layer(16)


		1:
			if avaible_units[1] >0:
				var yellow_unit = unit_package.instance()
				var unit_in_box = get_node("Interface/Boxes/BoxFoUnits2/Units").get_child((get_node("Interface/Boxes/BoxFoUnits2/Units").get_child_count()-1))
				var box = $Interface/Boxes/BoxFoUnits2
				if avaible_units[1]<=max_number_of_units_in_the_box:
					box.take_unit_out_of_box(unit_in_box)
				yellow_unit.tutorial_mode = tuto_mode
				yellow_unit.setup_start_position(transform.xform(unit_in_box.position))
				$Units/Yellow.add_child(yellow_unit)
				yellow_unit.unit_start_pos = unit_in_box.position + Vector2(160,0) 
				yellow_unit.unit_in_front_of_box_pos = pos
				yellow_unit.type_start_and_end_for_animation(yellow_unit.unit_start_pos,yellow_unit.unit_in_front_of_box_pos,ID,factor_1)
				yellow_unit.get_node("Unit").modulate = Color(1.0,1.0,0.0,0.3)
				yellow_unit.get_node("Mug").modulate = Color(0.63,0.4,0.4,0.3)
				yellow_unit.position = pos
				yellow_unit.set_kind_of_unit(1)
				#yellow_unit.get_node("Body").set_collision_layer(32)
				yellow_unit.get_node("Mouth").set_collision_layer(32)
				yellow_unit.set_collision_layer(32)


		2:
			if avaible_units[2] >0:
				var green_unit = unit_package.instance()
				var unit_in_box = get_node("Interface/Boxes/BoxFoUnits3/Units").get_child((get_node("Interface/Boxes/BoxFoUnits3/Units").get_child_count()-1))
				var box = $Interface/Boxes/BoxFoUnits3
				if avaible_units[2]<=max_number_of_units_in_the_box:
					box.take_unit_out_of_box(unit_in_box)
				green_unit.tutorial_mode = tuto_mode
				green_unit.setup_start_position(transform.xform(unit_in_box.position))
				$Units/Green.add_child(green_unit)
				green_unit.unit_start_pos = unit_in_box.position + Vector2(320,0)
				green_unit.unit_in_front_of_box_pos = pos
				green_unit.type_start_and_end_for_animation(green_unit.unit_start_pos,green_unit.unit_in_front_of_box_pos,ID,factor_1)
				green_unit.get_node("Unit").modulate = Color(0.0,1.0,0.0,0.3)
				green_unit.get_node("Mug").modulate = Color(0.63,0.4,0.4,0.3)
				green_unit.position = pos
				green_unit.set_kind_of_unit(2)
				#green_unit.get_node("Body").set_collision_layer(64)
				green_unit.get_node("Mouth").set_collision_layer(64)
				green_unit.set_collision_layer(64)


func create_random_ofset():
	randomize()
	var rand_x = rand_range(-100, 100)
	var rand_y = rand_range(-100, 100)
	var offset = Vector2(rand_x,rand_y)
	return offset


func _spawn_unit_v2(ID,pos):
	match ID:
		0:
			if avaible_units[0] >=0:
				var blue_unit = unit_package.instance()
				blue_unit.setup_start_position(pos)
				$Units/Blue.add_child(blue_unit)
				blue_unit.get_node("Unit").modulate = Color(0.0,0.0,1.0,1.0)
				blue_unit.set_kind_of_unit(0)
				blue_unit.get_node("Mouth").set_collision_layer(16)
				blue_unit.go_out_from_belly(pos)

		1:
			if avaible_units[1] >=0:
				var yellow_unit = unit_package.instance()
				yellow_unit.setup_start_position(pos)
				$Units/Yellow.add_child(yellow_unit)
				yellow_unit.get_node("Unit").modulate = Color(1.0,1.0,0.0,1.0)
				yellow_unit.set_kind_of_unit(1)
				yellow_unit.get_node("Mouth").set_collision_layer(32)
				yellow_unit.go_out_from_belly(pos)

		2:
			if avaible_units[2] >=0:
				var green_unit = unit_package.instance()
				green_unit.setup_start_position(pos)
				$Units/Green.add_child(green_unit)
				green_unit.get_node("Unit").modulate = Color(0.0,1.0,0.0,1.0)
				green_unit.set_kind_of_unit(2)
				green_unit.get_node("Mouth").set_collision_layer(64)
				green_unit.go_out_from_belly(pos)



func _update_number(ID):
	if avaible_units[ID] > 0:
		avaible_units[ID] -= 1
		units_in_battle[ID] += 1

func _unit_come_back_to_base(ID):
	avaible_units[ID] += 1
	emit_signal("number_of_avaible_units_changed",ID)
	if get_node("Interface/Boxes").get_child(ID).get_child(0).get_children().size() < 50:
		get_node("Interface/Boxes").get_child(ID).add_unit_to_box()

func there_was_a_hit(no_1,no_2):
	if state != YOU_ARE_ON_HUD:
		match difficulty_mode:
			0:
				if avaible_units[no_1] > 0:
					var box = get_node("Interface/Boxes").get_child(no_1)
					if avaible_units[no_1]<=max_number_of_units_in_the_box:
						box.take_unit_out_of_box(box.get_child(0).get_child(0))
					
					avaible_units[no_1] -= 1
					emit_signal("number_of_avaible_units_changed",no_1)
				else:
					_game_over()
			_:
				for i in range(no_2):
					if avaible_units[no_1] > 0:
						var box = get_node("Interface/Boxes").get_child(no_1)
						var number_of_unit_to_take = i
						var unit_to_take = box.get_child(0).get_child(number_of_unit_to_take)
						var is_there_any_reason_for_work = true
						while unit_to_take.is_supposed_to_dissapear == true:
							number_of_unit_to_take += 1
							if number_of_unit_to_take > avaible_units[no_1]:
								is_there_any_reason_for_work = false
								break
							unit_to_take = get_node("Interface/Boxes").get_child(no_1).get_child(0).get_child(number_of_unit_to_take)
						if is_there_any_reason_for_work == false:
							print("no reason for work")
							return
						unit_to_take.is_supposed_to_dissapear == true
						
						if avaible_units[no_1]<=max_number_of_units_in_the_box:
							box.take_unit_out_of_box(box.get_child(0).get_child(number_of_unit_to_take))
						avaible_units[no_1] -= 1
						emit_signal("number_of_avaible_units_changed",no_1)
					else:
						_game_over()


func _send_units_back_to_base():
	for unit in take_all_currently_in_battle_units():
		var unit_state = unit.state_machine._current_state.name
		if not (unit_state=="EatedState" or unit_state=="DieingState" or unit_state=="TakingOutOfBoxState"):
			unit.target_position = $Background/Vacuum/Coll.get_global_position()
			unit.state_machine.change_state_to("SendToBaseState")

func _take_of_unit_from_battle(ID):
	units_in_battle[ID] -= 1

func check_max_number_of_unit():
	var a = avaible_units[0]+units_in_battle[0]
	var b = avaible_units[1]+units_in_battle[1]
	var c = avaible_units[2]+units_in_battle[2]
	max_number_of_units = int(max(max(a,b),c))

func check_overall_number_of_specific_unit(ID):
	var number = avaible_units[ID]+units_in_battle[ID]
	return number

func take_all_currently_in_battle_units():
	var units_in_battle = []
	for i in get_node("Units").get_children().size():
		if not get_node("Units").get_child(i).get_children().empty():
			for x in get_node("Units").get_child(i).get_children().size():
				var unit = get_node("Units").get_child(i).get_child(x)
				units_in_battle.append(unit)
	return units_in_battle


func locate_your_score_in_the_label(killed_enemies,level,difficulty):
	var blabla = $SAVEDSCORES/VBoxContainer/Scores
	var quantity_to_check = blabla.get_children().size()
	for i in blabla.get_children().size():
		quantity_to_check -= 1
		if int(blabla.get_child(i).get_child(5).text) < killed_enemies:
			for x in quantity_to_check:
				blabla.get_children()[-1-x].get_child(5).text = blabla.get_children()[-2-x].get_child(5).text
				blabla.get_children()[-1-x].get_child(3).text = blabla.get_children()[-2-x].get_child(3).text
				blabla.get_children()[-1-x].get_child(1).text = blabla.get_children()[-2-x].get_child(1).text
				match blabla.get_children()[-1-x].get_child(1).text:
					"EASY":
						blabla.get_children()[-1-x].modulate = Color(1,1,1,1)
					"MID":
						blabla.get_children()[-1-x].modulate = Color(1,0.5,0.5,1)
					"HARD":
						blabla.get_children()[-1-x].modulate = Color(1,0,0,1)
			blabla.get_child(i).get_child(5).text = str(killed_enemies)
			blabla.get_child(i).get_child(3).text = str(level)
			match difficulty:
				0:
					blabla.get_child(i).get_child(1).text = "EASY"
					blabla.get_child(i).modulate = Color(1,1,1,1)
				1:
					blabla.get_child(i).get_child(1).text = "MID"
					blabla.get_child(i).modulate = Color(1,0.5,0.5,1)
				2:
					blabla.get_child(i).get_child(1).text = "HARD"
					blabla.get_child(i).modulate = Color(1,0,0,1)
			return
		else:
			continue

func show_in_game_interface():
	$Interface/AnimPlayer.play("In_game_interface_on")

func hide_in_game_interface():
	$Interface/AnimPlayer.play("In_game_interface_off")

func show_in_tutorial_interface():
	$Interface/AnimPlayer.play("In_tutorial_interface_on")

func hide_in_tutorial_interface():
	$Interface/AnimPlayer.play("In_tutorial_interface_off")


func _show_confirmation_for_saving():
	$HUD/SaveScoreButton.hide()
	match just_started_new_game:
		false:
			$HUD/HUDAnim.play("Move VBox OUT ")
		true:
			$HUD/HUDAnim.play("Move VBox (ALL) OUT")
	$HUD/VBox.show()
	yield($HUD/HUDAnim,"animation_finished")
	$HUD/VBox.hide()
	#$HUD/VBox.rect_position.x = 500
	$HUD/Label.set_text("ARE YOU SURE?")
	$HUD/Label.show()
	$HUD/Comment.show()
	$HUD/VBoxConfirmation.show()



func _resign_from_saving():
	
	$HUD/Label.hide()
	$HUD/Comment.hide()
	$HUD/VBoxConfirmation.hide()
	match just_started_new_game:
		false:
			$HUD/HUDAnim.play("Move VBox IN")
		true:
			$HUD/HUDAnim.play("Move VBox (ALL) IN")
	$HUD/VBox.show()
	yield($HUD/HUDAnim,"animation_finished")
	#$HUD/VBox.rect_position.x = 0
	#$HUD/VBox.show()
	if not just_saved:
		$HUD/SaveScoreButton.show()

#func _save_score():
#	_resign_from_saving()
#	$HUD/SaveScoreButton.hide()
#	$HUD/VBox.show()
#	if not just_saved:
#		just_saved = true

func _save_score():
	_resign_from_saving()
	$HUD/SaveScoreButton.hide()
	if not just_saved:
		print("fortuna")
		locate_your_score_in_the_label(killed_enemies,DifficultyScaler.difficulty_level,difficulty_mode)
		var new_save = game_save_class.new()
		new_save.dif_1 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/Difficulty.text
		new_save.lev_1 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/LevelNumber.text
		new_save.kills_1 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/KillNumber.text
		new_save.dif_2 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/Difficulty.text
		new_save.lev_2 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/LevelNumber.text
		new_save.kills_2 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/KillNumber.text
		new_save.dif_3 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/Difficulty.text
		new_save.lev_3 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/LevelNumber.text
		new_save.kills_3 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/KillNumber.text
		new_save.dif_4 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/Difficulty.text
		new_save.lev_4 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/LevelNumber.text
		new_save.kills_4 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/KillNumber.text
		new_save.dif_5 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/Difficulty.text
		new_save.lev_5 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/LevelNumber.text
		new_save.kills_5 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/KillNumber.text
		new_save.dif_6 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/Difficulty.text
		new_save.lev_6 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/LevelNumber.text
		new_save.kills_6 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/KillNumber.text
		new_save.dif_7 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/Difficulty.text
		new_save.lev_7 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/LevelNumber.text
		new_save.kills_7 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/KillNumber.text
		new_save.dif_8 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/Difficulty.text
		new_save.lev_8 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/LevelNumber.text
		new_save.kills_8 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/KillNumber.text
		new_save.dif_9 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/Difficulty.text
		new_save.lev_9 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/LevelNumber.text
		new_save.kills_9 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/KillNumber.text
		new_save.dif_10 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/Difficulty.text
		new_save.lev_10 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/LevelNumber.text
		new_save.kills_10 = $SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/KillNumber.text
#		ResourceSaver.save("res://05_savings/MySavings.tres", new_save)
		ResourceSaver.save("user://MySavings.res", new_save)
		just_saved = true

func verfy_save(saved_score):
	for v in save_vars:
		if saved_score.get(v) == null:
			return false
	return true

func set_color_for_difficult_mode():
	for score in $SAVEDSCORES/VBoxContainer/Scores.get_children():
		match score.get_child(1).text:
			"EASY":
				score.modulate = Color(1,1,1,1)
			"MID":
				score.modulate = Color(1,0.5,0.5,1)
			"HARD":
				score.modulate = Color(1,0,0,1)


func _load_saved_score():
	var dir = Directory.new()
	if not dir.file_exists("user://MySavings.res"):
		return false
	var saved_score = load("user://MySavings.res")
	if not verfy_save(saved_score):
		return false
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/Difficulty.text = saved_score.dif_1
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/LevelNumber.text = saved_score.lev_1
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr1/KillNumber.text = saved_score.kills_1
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/Difficulty.text = saved_score.dif_2
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/LevelNumber.text = saved_score.lev_2
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr2/KillNumber.text = saved_score.kills_2
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/Difficulty.text = saved_score.dif_3
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/LevelNumber.text = saved_score.lev_3
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr3/KillNumber.text = saved_score.kills_3
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/Difficulty.text = saved_score.dif_4
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/LevelNumber.text = saved_score.lev_4
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr4/KillNumber.text = saved_score.kills_4
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/Difficulty.text = saved_score.dif_5
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/LevelNumber.text = saved_score.lev_5
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr5/KillNumber.text = saved_score.kills_5
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/Difficulty.text = saved_score.dif_6
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/LevelNumber.text = saved_score.lev_6
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr6/KillNumber.text = saved_score.kills_6
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/Difficulty.text = saved_score.dif_7
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/LevelNumber.text = saved_score.lev_7
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr7/KillNumber.text = saved_score.kills_7
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/Difficulty.text = saved_score.dif_8
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/LevelNumber.text = saved_score.lev_8
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr8/KillNumber.text = saved_score.kills_8
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/Difficulty.text = saved_score.dif_9
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/LevelNumber.text = saved_score.lev_9
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr9/KillNumber.text = saved_score.kills_9
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/Difficulty.text = saved_score.dif_10
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/LevelNumber.text = saved_score.lev_10
	$SAVEDSCORES/VBoxContainer/Scores/ScoreNr10/KillNumber.text = saved_score.kills_10
	set_color_for_difficult_mode()
	return true

func difficulty_checker():
	var a = DifficultyScaler.difficulty_level
	DifficultyScaler.check_level(max_number_of_units)
	max_level = max(max_level,DifficultyScaler.difficulty_level)
	var b = DifficultyScaler.difficulty_level
	if a != b and state!=YOU_ARE_ON_HUD :
		$Interface/LevelNumber.set_text("Level " +str(DifficultyScaler.difficulty_level))
		_in_game_enemy_spawner(spawner_time_settings(DifficultyScaler.difficulty_level))


func spawn_unit_for_tuto(pos , rot , tuto_mode=true):
	var blue_unit = unit_package.instance()
	blue_unit.tutorial_mode = tuto_mode
	blue_unit.setup_start_position(pos)
	$Units/Blue.add_child(blue_unit)
	blue_unit.rotation_degrees = rot
	blue_unit.get_node("Unit").modulate = Color(0.0,0.0,1.0,1)
	blue_unit.get_node("Mug").modulate = Color(0.63,0.4,0.4,1)
	blue_unit.set_kind_of_unit(0)
	blue_unit.get_node("Mouth").set_collision_layer(16)
	blue_unit.set_collision_layer(16)
	blue_unit.activate_collision_areas()

func test_enemy_start():
	_tuto_show_enemy(0,true,Vector2(250,675))
	_tuto_show_enemy(4,true,Vector2(250,675))

