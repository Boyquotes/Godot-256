extends Node2D

signal action_done


onready var anim_tree = $AnimTree
onready var state_machine = $StateMachine

onready var prog_bar1 = $HeroInerface/Stats/ProgBar1
onready var prog_bar2 = $HeroInerface/Stats/ProgBar2

var action_stamina_cost = {
	0:1,#DEF_TOP
	1:1,#DEF_MID
	2:1,#DEF_BOT
	3:2,#ATC_TOP
	4:2,#ATC_MID
	5:2,#ATC_BOT
	6:0 #NO_ACT
}

var sequence_of_actions = []

var actual_stamina
var actual_life
var is_performing_sequance_of_action = false
var is_ready = false setget set_is_ready
var is_performing_action = false setget set_is_performing_action
var actual_action = ACTIONS.DEF_TOP setget set_actual_action
var actual_action_name
var you_are = YOU_ARE.HERO setget set_you_are
var sequance_ready = false
var one_of_fighters_lost_all_life_points = false
var is_defeated = false

enum YOU_ARE {
	HERO
	OPPONENT
}


enum ACTIONS {
	DEF_TOP,
	DEF_MID,
	DEF_BOT,
	ATC_TOP,
	ATC_MID,
	ATC_BOT,
	NO_ACT,
	ATC_TOP_FAIL,       #7
	ATC_TOP_SUCCESS,    #8
	ATC_MID_FAIL,       #9
	ATC_MID_SUCCESS,    #10
	ATC_BOT_FAIL,       #11
	ATC_BOT_SUCCESS,    #12
	DEF_TOP_LONG,       #13
	DEF_MID_LONG,       #14
	DEF_BOT_LONG        #15
}

func set_actual_action(value):
	match value:
		0:
			actual_action = ACTIONS.DEF_TOP
			state_machine.change_state_to("DefendTopState")
		1:
			actual_action = ACTIONS.DEF_MID
			state_machine.change_state_to("DefendMidState")
		2:
			actual_action = ACTIONS.DEF_BOT
			state_machine.change_state_to("DefendBotState")
		3:
			actual_action = ACTIONS.ATC_TOP
			state_machine.change_state_to("AttackTopState")
		4:
			actual_action = ACTIONS.ATC_MID
			state_machine.change_state_to("AttackMidState")
		5:
			actual_action = ACTIONS.ATC_BOT
			state_machine.change_state_to("AttackBotState")
		6:
			actual_action = ACTIONS.NO_ACT
			state_machine.change_state_to("NoActionState")
		7:
			actual_action = ACTIONS.ATC_TOP_FAIL
			state_machine.change_state_to("AttackTopFailState")
		8:
			actual_action = ACTIONS.ATC_TOP_SUCCESS
			state_machine.change_state_to("AttackTopSuccessState")
		9:
			actual_action = ACTIONS.ATC_MID_FAIL
			state_machine.change_state_to("AttackMidFailState")
		10:
			actual_action = ACTIONS.ATC_MID_SUCCESS
			state_machine.change_state_to("AttackMidSuccessState")
		11:
			actual_action = ACTIONS.ATC_BOT_FAIL
			state_machine.change_state_to("AttackBotFailState")
		12:
			actual_action = ACTIONS.ATC_BOT_SUCCESS
			state_machine.change_state_to("AttackBotSuccessState")
		13:
			actual_action = ACTIONS.DEF_TOP_LONG
			state_machine.change_state_to("DefendTopLongState")
		14:
			actual_action = ACTIONS.DEF_MID_LONG
			state_machine.change_state_to("DefendMidLongState")
		15:
			actual_action = ACTIONS.DEF_BOT_LONG
			state_machine.change_state_to("DefendBotLongState")




func set_is_performing_action(value:bool):
	if not is_performing_sequance_of_action:
		is_performing_action = value
		if value==false:
			state_machine.change_state_to("ReadyIdleState")
			yield(get_tree().create_timer(0.1),"timeout")
			emit_signal("action_done")
	if is_performing_sequance_of_action:
		is_performing_action = value
		if value==false:
			state_machine.change_state_to("ReadyIdleState")
			yield(get_tree().create_timer(0.1),"timeout")
			emit_signal("action_done")


func set_is_ready(value:bool):
	is_ready = value
#	if value:
#		state_machine.change_state_to("ReadyIdleState")

func set_you_are(value):
	match value:
		0:
			you_are = YOU_ARE.HERO
			setup_for_you()
		1:
			you_are = YOU_ARE.OPPONENT


func _ready():
	prog_bar1.start_setup(2)
	prog_bar2.start_setup(1)
	pass # Replace with function body.

func _on_TopDef_button_down():
	$HeroInerface/Actions/ActionsTOP/TopDef.modulate = Color(0.5,0.5,0.5,1)
func _on_TopDef_button_up():
	$HeroInerface/Actions/ActionsTOP/TopDef.modulate = Color(1,1,1,1)
	prepare_action_sequance(0)

func _on_MidDef_button_down():
	$HeroInerface/Actions/ActionsMID/MidDef.modulate = Color(0.5,0.5,0.5,1)
func _on_MidDef_button_up():
	$HeroInerface/Actions/ActionsMID/MidDef.modulate = Color(1,1,1,1) 
	prepare_action_sequance(1)

func _on_BotDef_button_down():
	$HeroInerface/Actions/ActionsBOT/BotDef.modulate = Color(0.5,0.5,0.5,1)
func _on_BotDef_button_up():
	$HeroInerface/Actions/ActionsBOT/BotDef.modulate = Color(1,1,1,1) 
	prepare_action_sequance(2)

func _on_TopAtt_button_down():
	$HeroInerface/Actions/ActionsTOP/TopAtt.modulate = Color(0.5,0.5,0.5,1)
func _on_TopAtt_button_up():
	$HeroInerface/Actions/ActionsTOP/TopAtt.modulate = Color(1,1,1,1) 
	prepare_action_sequance(3)

func _on_MidAtt_button_down():
	$HeroInerface/Actions/ActionsMID/MidAtt.modulate = Color(0.5,0.5,0.5,1)
func _on_MidAtt_button_up():
	$HeroInerface/Actions/ActionsMID/MidAtt.modulate = Color(1,1,1,1) 
	prepare_action_sequance(4)

func _on_BotAtt_button_down():
	$HeroInerface/Actions/ActionsBOT/BotAtt.modulate = Color(0.5,0.5,0.5,1)
func _on_BotAtt_button_up():
	$HeroInerface/Actions/ActionsBOT/BotAtt.modulate = Color(1,1,1,1) 
	prepare_action_sequance(5)

func setup_for_you():
	position.x = 180
	position.y = 320
	$AnimatedSprite.position.x = 0
	$AnimatedSprite.position.y = 0
	$AnimatedSprite.rotation_degrees = 0
	$HeroInerface/Actions.visible = false

func setup_for_opponent():
	position.x = 760
	position.y = 320
#	scale.x = -1
	$HeroInerface/Actions.visible = false


func prepare_action_sequance(action_nr):
	if is_ready:
		if not is_performing_action:
			if action_stamina_cost[action_nr] <= actual_stamina:
				set_actual_action(action_nr)
				use_stamina(action_stamina_cost[action_nr])
				GlobalSignals.emit_signal("_show_action_description",action_nr,you_are)

				sequence_of_actions.append(action_nr)
			else:
				print("no stamina!")
		else:
			print("wait")
	else:
		print("hero not ready!")

func perform_sequance_of_actions():
	if not sequence_of_actions.empty():
		is_performing_sequance_of_action = true
		for action in sequence_of_actions:
			if you_are == 1:
				use_stamina(action_stamina_cost[action])
			set_actual_action(action)
			GlobalSignals.emit_signal("_show_action_description",action,you_are)
			yield(self,"action_done")
			yield(get_tree().create_timer(0.2),"timeout")
		is_performing_sequance_of_action = false
		match you_are:
			0:
				pass
			1:
				GlobalSignals.emit_signal("_opponent_sequance_completed")
#		sequence_of_actions = []

func perform_final_sequance_of_actions():
	if not sequence_of_actions.empty():
		is_performing_sequance_of_action = true
		var interaction_nr = 0
		for action in sequence_of_actions:
			if one_of_fighters_lost_all_life_points:
				return
			set_actual_action(action)
			yield(self,"action_done")
			if you_are == 0:
				GlobalSignals.emit_signal("_show_interaction",interaction_nr)
				interaction_nr += 1

		is_performing_sequance_of_action = false
		sequence_of_actions = []
		sequance_ready = false
	
	if not one_of_fighters_lost_all_life_points:
		GlobalSignals.emit_signal("_exchange_of_hits_is_over")


func start_sequance_from_beginning():
	sequence_of_actions = []
	load_stamina()

func load_stamina():
	var short = CurrentHero.current_hero + "Stats"
	actual_stamina = get_tree().root.get_node(short).stamina_points
	prog_bar1.set_number_of_spaces(actual_stamina)

func load_life():
	var short = CurrentHero.current_hero + "Stats"
	actual_life = get_tree().root.get_node(short).life_points
	prog_bar2.set_number_of_spaces(actual_life)

func use_stamina(cost):
	actual_stamina -= cost
	match cost:
		1:
			prog_bar1.lost_point(cost)
		2:
			prog_bar1.lost_point(cost)


func lost_life(cost):
	actual_life -= cost
	if actual_life == 0:
		is_defeated = true
		GlobalSignals.emit_signal("_one_of_the_heroes_is_dead")
	match cost:
		1:
			prog_bar2.lost_point(cost)
		2:
			prog_bar2.lost_point(cost)
			prog_bar2.lost_point(cost)


func your_turn_to_prepare_sequance():
	state_machine.change_state_to("MoveINState")
	$FreezePosture.visible = true
	$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position + Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($HeroInerface, "rect_position",
$HeroInerface.rect_position, ($HeroInerface.rect_position + Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate",
Color(1,1,1,1),Color(0,0,0,0.5), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
#	if not is_ready:
#		state_machine.change_state_to("ReadyState")
	$HeroInerface/Actions.visible = true
	GlobalSignals.emit_signal("_your_turn")


func your_time_to_prepare_sequance_is_up():
	$HeroInerface/Actions.visible = false
	if is_ready:
		state_machine.change_state_to("MoveOUTState")
	$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position - Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($HeroInerface, "rect_position",
$HeroInerface.rect_position, ($HeroInerface.rect_position - Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate",
Color(0,0,0,0.5),Color(1,1,1,1), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	$FreezePosture.visible = false
	state_machine.change_state_to("SwingSidewaysState")
	sequance_ready = true
	CurrentHero.hero_sequance = sequence_of_actions
	compare_sequances()
	GlobalSignals.emit_signal("_you_prepared_your_sequance")

func cancel_your_turn():
	$HeroInerface/Actions.visible = false
	if is_ready:
		state_machine.change_state_to("MoveOUTState")
	$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position - Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($HeroInerface, "rect_position",
$HeroInerface.rect_position, ($HeroInerface.rect_position - Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate",
Color(0,0,0,0.5),Color(1,1,1,1), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	$FreezePosture.visible = false
	state_machine.change_state_to("SwingSidewaysState")
	start_sequance_from_beginning()

#################################
###### OPPONENT FUNCTIONS #######
#################################
func opponent_back_on_position():
	state_machine.change_state_to("MoveOUTState")
	$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position + Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($HeroInerface, "rect_position",
$HeroInerface.rect_position, ($HeroInerface.rect_position + Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate",
Color(0,0,0,0),Color(1,1,1,1), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	$FreezePosture.visible = false
	state_machine.change_state_to("SwingSidewaysState")
	GlobalSignals.emit_signal("_opponent_get_back_from_showing_sequance")
	sequance_ready = true

func show_opponent_combination():
	state_machine.change_state_to("MoveINState")
	$FreezePosture.visible = true
	$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position - Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($HeroInerface, "rect_position",
$HeroInerface.rect_position, ($HeroInerface.rect_position - Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate",
Color(1,1,1,1),Color(0,0,0,1), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	perform_sequance_of_actions()

func to_draw_sequance_of_opponent_actions():
	var temporary_stamina = actual_stamina
	var first_rand_int
	var second_rand_int
	while temporary_stamina>0:
		randomize()
		first_rand_int = randi() % 100 + 1
		second_rand_int = randi() % 100 + 1
		if temporary_stamina >= 2:
			if first_rand_int>=1 and first_rand_int<=35:
				if second_rand_int>=1 and second_rand_int<=33:
					sequence_of_actions.append(0)
				elif second_rand_int>33 and second_rand_int<=66:
					sequence_of_actions.append(1)
				elif second_rand_int>66 and second_rand_int<=100:
					sequence_of_actions.append(2)
				else:
					print("STH WRONG WITH to_draw_sequance")
				temporary_stamina -=1
			if first_rand_int>35 and first_rand_int<=100:
				if second_rand_int>=1 and second_rand_int<=33:
					sequence_of_actions.append(3)
				elif second_rand_int>33 and second_rand_int<=66:
					sequence_of_actions.append(4)
				elif second_rand_int>66 and second_rand_int<=100:
					sequence_of_actions.append(5)
				else:
					print("STH WRONG WITH to_draw_sequance")
				temporary_stamina -=2
		elif temporary_stamina == 1:
			if second_rand_int>=1 and second_rand_int<=33:
				sequence_of_actions.append(0)
			elif second_rand_int>33 and second_rand_int<=66:
				sequence_of_actions.append(1)
			elif second_rand_int>66 and second_rand_int<=100:
				sequence_of_actions.append(2)
			else:
				print("STH WRONG WITH to_draw_sequance")
			temporary_stamina -=1
	print(sequence_of_actions)
	CurrentHero.opponent_sequance = sequence_of_actions
	show_opponent_combination()

######################
###### FOR BOTH ######
######################

func start_exchange_of_hits():
	match you_are:
		0:
			$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position + Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			state_machine.change_state_to("MoveINState")
		1:
			$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position - Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			state_machine.change_state_to("MoveINState")
	$Tween.start()
	yield($Tween,"tween_completed")
	perform_final_sequance_of_actions()



func end_exchange_of_hits():
	match you_are:
		0:
			match is_defeated:
				false:
					$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position - Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					state_machine.change_state_to("MoveOUTState")
					$Tween.start()
					yield($Tween,"tween_completed")
					state_machine.change_state_to("SwingSidewaysState")
				true:
					state_machine.change_state_to("DefeatedState")
		1:
			match is_defeated:
				false:
					$Tween.interpolate_property($AnimatedSprite, "position",
$AnimatedSprite.position, ($AnimatedSprite.position + Vector2(200,0)), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					state_machine.change_state_to("MoveOUTState")
					$Tween.start()
					yield($Tween,"tween_completed")

					state_machine.change_state_to("SwingSidewaysState")
				true:
					state_machine.change_state_to("DefeatedState")

	match one_of_fighters_lost_all_life_points:
		false:
			GlobalSignals.emit_signal("_you_can_see_another_sequance")
		true:
			if you_are==0:
				GlobalSignals.emit_signal("_fight_is_over")


func compare_sequances():
	var size_difference =  CurrentHero.opponent_sequance.size() - CurrentHero.hero_sequance.size()
	if size_difference > 0:
		for i in range(size_difference):
			CurrentHero.hero_sequance.append(6)
	elif size_difference < 0:
		for i in range(abs(size_difference)):
			CurrentHero.opponent_sequance.append(6)

	CurrentHero.interactions = []
	for i in range(CurrentHero.opponent_sequance.size()):
		var hero_action_nr = CurrentHero.hero_sequance[i]
		var oppo_action_nr = CurrentHero.opponent_sequance[i]
		CurrentHero.interactions.append(CurrentHero.matrix_of_action_dependencies[oppo_action_nr][hero_action_nr])

func adjust_animations():
	print(sequence_of_actions)
	print(CurrentHero.interactions)
	for i in sequence_of_actions.size():
		print(sequence_of_actions[i])
		var a=sequence_of_actions[i]
		match CurrentHero.interactions[i]:
			0:
				if a==0 or a==1 or a==2:
					match a:
						0:
							sequence_of_actions[i] = 13
						1:
							sequence_of_actions[i] = 14
						2:
							sequence_of_actions[i] = 15
			1:
				if a==0 or a==1 or a==2:
					match a:
						0:
							sequence_of_actions[i] = 13
						1:
							sequence_of_actions[i] = 14
						2:
							sequence_of_actions[i] = 15
				else:
					match a:
						3:
							sequence_of_actions[i] = 7
						4:
							sequence_of_actions[i] = 9
						5:
							sequence_of_actions[i] = 11
			2:
				match you_are:
					0:
						if a==0 or a==1 or a==2:
							match a:
								0:
									sequence_of_actions[i] = 13
								1:
									sequence_of_actions[i] = 14
								2:
									sequence_of_actions[i] = 15
						else:
							match a:
								3:
									sequence_of_actions[i] = 7
								4:
									sequence_of_actions[i] = 9
								5:
									sequence_of_actions[i] = 11
					1:
						if a==0 or a==1 or a==2:
							match a:
								0:
									sequence_of_actions[i] = 13
								1:
									sequence_of_actions[i] = 14
								2:
									sequence_of_actions[i] = 15
						else:
							match a:
								3:
									sequence_of_actions[i] = 8
								4:
									sequence_of_actions[i] = 10
								5:
									sequence_of_actions[i] = 12
			3:
				match you_are:
					0:
						match a:
							3:
								sequence_of_actions[i] = 8
							4:
								sequence_of_actions[i] = 10
							5:
								sequence_of_actions[i] = 12
					1:
						if a==0 or a==1 or a==2:
							match a:
								0:
									sequence_of_actions[i] = 13
								1:
									sequence_of_actions[i] = 14
								2:
									sequence_of_actions[i] = 15






