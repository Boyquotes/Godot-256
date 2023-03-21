extends Node

export(Script) var game_save_class

var hero_package = load("res://02_Scenes/Heroes/Hero.tscn")
var leno_package = load("res://02_Scenes/Heroes/Lenoland.tscn")
var bloin_package = load("res://02_Scenes/Heroes/Bloin.tscn")
var thog_package = load("res://02_Scenes/Heroes/Thog.tscn")
var randomguy_package = load("res://02_Scenes/Heroes/RandomGuy.tscn")


var hero_was_hitted_package = load("res://02_Scenes/Efects/HeroWasHitted.tscn")
var no_interaction_package = load("res://02_Scenes/Efects/NoInteraction.tscn")
var opponent_was_hitted_package = load("res://02_Scenes/Efects/OpponentWasHitted.tscn")
var there_was_block_package = load("res://02_Scenes/Efects/ThereWasBlock.tscn")
var action_description_package = load("res://02_Scenes/Efects/ActionDescription.tscn")

func _ready():
	_load_stats()
	on_load_hero_availability()
	### FROM ARENA ###
	GlobalSignals.connect("_you_win",self,"on_you_win")
	GlobalSignals.connect("_you_lost",self,"on_you_lost")
	GlobalSignals.connect("_ready_to_see_opponent_combination",self,"on_ready_to_see_opponent_combination")
	GlobalSignals.connect("_your_time_is_up",self,"on_your_time_is_up")
	GlobalSignals.connect("_your_comb_ready_before_times_up",self,"on_your_comb_ready_before_times_up")
	GlobalSignals.connect("_prepare_new_combination_for_hero",self,"on_prepare_new_combination_for_hero")
	GlobalSignals.connect("_start_exchange_of_hits",self,"on_start_exchange_of_hits")
	GlobalSignals.connect("_arena_is_asking_a_question",self,"on_arena_is_asking_a_question")
	GlobalSignals.connect("_arena_stopped_asking_a_question",self,"on_arena_stopped_asking_a_question")
	GlobalSignals.connect("_player_wants_to_watch_comb_again",self,"on_player_wants_to_watch_comb_again")
	
	### FROM PAUSE PANEL ###
	GlobalSignals.connect("_game_paused",self,"on_game_paused")
	GlobalSignals.connect("_game_unpaused",self,"on_game_unpaused")
	GlobalSignals.connect("_resign_from_fight",self,"on_resign_from_fight")
	
	### FROM MENU ###
	GlobalSignals.connect("_hero_picked",self,"on_hero_picked")
	GlobalSignals.connect("_prepare_opponent",self,"on_prepare_opponent")
	GlobalSignals.connect("_prepare_your_hero",self,"on_prepare_your_hero")
	GlobalSignals.connect("_new_fight_started",self,"on_new_fight_started")
	
	### FROM HERO ###
	GlobalSignals.connect("_opponent_sequance_completed",self,"on_opponent_sequance_completed")
	GlobalSignals.connect("_opponent_get_back_from_showing_sequance",self,"on_opponent_get_back_from_showing_sequance")
	GlobalSignals.connect("_your_turn",self,"on_your_turn")
	GlobalSignals.connect("_you_prepared_your_sequance",self,"on_you_prepared_your_sequance")
	GlobalSignals.connect("_exchange_of_hits_is_over",self,"on_exchange_of_hits_is_over")
	GlobalSignals.connect("_show_interaction",self,"on_show_interaction")
	GlobalSignals.connect("_you_can_see_another_sequance",self,"on_you_can_see_another_sequance")
	GlobalSignals.connect("_one_of_the_heroes_is_dead",self,"on_one_of_the_heroes_is_dead")
	GlobalSignals.connect("_fight_is_over",self,"on_fight_is_over")
	GlobalSignals.connect("_show_action_description",self,"on_show_action_description")
	GlobalSignals.connect("_load_hero_availability",self,"on_load_hero_availability")
	
	### COMMON SIGNALS ###
	GlobalSignals.connect("_save_stats",self,"on_save_stats")
	
	pass # Replace with function body.


func on_load_hero_availability():
	var stage1_short = $Menu/TakeHero/MarginContainer/Background/SmallStage1
	var stage2_short = $Menu/TakeHero/MarginContainer/Background/SmallStage2
	var stage3_short = $Menu/TakeHero/MarginContainer/Background/SmallStage3
	var stage4_short = $Menu/TakeHero/MarginContainer/Background/SmallStage4
	$Menu.is_hero_on_screen_availabe = GunterStats.available
	if LenolandStats.available:
		stage2_short.get_node("Hero2").modulate = Color(1,1,1,1)
		stage2_short.get_node("Condition").visible = false
	else:
		stage2_short.get_node("Hero2").modulate = Color(0,0,0,1)
		stage2_short.get_node("Condition").visible = true
	if BloinStats.available:
		stage3_short.get_node("Hero3").modulate = Color(1,1,1,1)
		stage3_short.get_node("Condition").visible = false
	else:
		stage3_short.get_node("Hero3").modulate = Color(0,0,0,1)
		stage3_short.get_node("Condition").visible = true
	if ThogStats.available:
		stage4_short.get_node("Hero4").modulate = Color(1,1,1,1)
		stage4_short.get_node("Condition").visible = false
	else:
		stage4_short.get_node("Hero4").modulate = Color(0,0,0,1)
		stage4_short.get_node("Condition").visible = true

###################
### SAVE SYSTEM ###
func save_stats():
	var new_save = game_save_class.new()

	new_save.Gunter_stats["rank"] = GunterStats.rank
	new_save.Gunter_stats["won_fights"] = GunterStats.won_fights
	new_save.Gunter_stats["gained_experiance"] = GunterStats.gained_experiance
	new_save.Gunter_stats["gold"] = GunterStats.gold
	new_save.Gunter_stats["life_points"] = GunterStats.life_points
	new_save.Gunter_stats["stamina_points"] = GunterStats.stamina_points
	new_save.Gunter_stats["armor"] = GunterStats.armor
	new_save.Gunter_stats["attack_force"] = GunterStats.attack_force
	new_save.Gunter_stats["top_border_of_next_rank"] = GunterStats.top_border_of_next_rank
	new_save.Gunter_stats["available"] = GunterStats.available

	new_save.Lenoland_stats["rank"] = LenolandStats.rank
	new_save.Lenoland_stats["won_fights"] = LenolandStats.won_fights
	new_save.Lenoland_stats["gained_experiance"] = LenolandStats.gained_experiance
	new_save.Lenoland_stats["gold"] = LenolandStats.gold
	new_save.Lenoland_stats["life_points"] = LenolandStats.life_points
	new_save.Lenoland_stats["stamina_points"] = LenolandStats.stamina_points
	new_save.Lenoland_stats["armor"] = LenolandStats.armor
	new_save.Lenoland_stats["attack_force"] = LenolandStats.attack_force
	new_save.Lenoland_stats["top_border_of_next_rank"] = LenolandStats.top_border_of_next_rank
	new_save.Lenoland_stats["available"] = LenolandStats.available
	
	new_save.Bloin_stats["rank"] = BloinStats.rank
	new_save.Bloin_stats["won_fights"] = BloinStats.won_fights
	new_save.Bloin_stats["gained_experiance"] = BloinStats.gained_experiance
	new_save.Bloin_stats["gold"] = BloinStats.gold
	new_save.Bloin_stats["life_points"] = BloinStats.life_points
	new_save.Bloin_stats["stamina_points"] = BloinStats.stamina_points
	new_save.Bloin_stats["armor"] = BloinStats.armor
	new_save.Bloin_stats["attack_force"] = BloinStats.attack_force
	new_save.Bloin_stats["top_border_of_next_rank"] = BloinStats.top_border_of_next_rank
	new_save.Bloin_stats["available"] = BloinStats.available

	new_save.Thog_stats["rank"] = ThogStats.rank
	new_save.Thog_stats["won_fights"] = ThogStats.won_fights
	new_save.Thog_stats["gained_experiance"] = ThogStats.gained_experiance
	new_save.Thog_stats["gold"] = ThogStats.gold
	new_save.Thog_stats["life_points"] = ThogStats.life_points
	new_save.Thog_stats["stamina_points"] = ThogStats.stamina_points
	new_save.Thog_stats["armor"] = ThogStats.armor
	new_save.Thog_stats["attack_force"] = ThogStats.attack_force
	new_save.Thog_stats["top_border_of_next_rank"] = ThogStats.top_border_of_next_rank
	new_save.Thog_stats["available"] = ThogStats.available


	ResourceSaver.save("res://04_Savings/MySavings.tres", new_save)
#	ResourceSaver.save("user://MySavings.res", new_save)

var save_vars = ["Gunter_stats", "Lenoland_stats","Bloin_stats","Thog_stats" ]

func verfy_save(saved_score):
	for v in save_vars:
		if saved_score.get(v) == null:
			print("error verfy save")
			return false
	return true

func _load_stats():
	var dir = Directory.new()
	if not dir.file_exists("user://MySavings.res"):
		return false
	var saved_stats = load("user://MySavings.res")
	if not verfy_save(saved_stats):
		return false
	for i in saved_stats.Gunter_stats.keys():
		var type = i
		if type in GunterStats:
			GunterStats.set(type,saved_stats.Gunter_stats[i])
	for i in saved_stats.Lenoland_stats.keys():
		var type = i
		if type in LenolandStats:
			LenolandStats.set(type,saved_stats.Lenoland_stats[i])
	for i in saved_stats.Bloin_stats.keys():
		var type = i
		if type in BloinStats:
			BloinStats.set(type,saved_stats.Bloin_stats[i])
	for i in saved_stats.Thog_stats.keys():
		var type = i
		if type in ThogStats:
			ThogStats.set(type,saved_stats.Thog_stats[i])
	return true
### SAVE SYSTEM ###
###################

############SOME FUNCTIONS###############
func make_herose_interfaces_visible_again():
	$Arena/Hero.get_child(0).get_node("HeroInerface").visible = true
	$Arena/Opponent.get_child(0).get_node("HeroInerface").visible = true


#######################SIGNALS#######################
##################
### FROM ARENA ###
##################
func on_you_win():
	$Menu/FightResults/Margin/Background/SignLost.visible = false
	$Menu/FightResults/Margin/Background/SignWin.visible = true
	$Menu/Anim.play("Move_SideBoards")
	$Arena.modulate = Color(1,1,1,1)
	$Frame.modulate = Color(1,1,1,1)
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Arena.set_active_label(0)
	$Menu/FightResults.visible = true
	$Menu/FightResults.modulate = Color(0,0,0,1)
	$Menu/Anim.play_backwards("Move_SideBoards")
	$Menu/AnimFade.play_backwards("Fade_FightResults")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Menu/Anim.play("Move_BackBoard")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Menu/Anim.play("Move_FightAgain")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$PausePanel.pause_button_in_start_pos()
	$Menu.show_you_win()
	$Menu.back_button.disabled = false
	$Menu.fight_again_button.disabled = false

func on_you_lost():
	$Menu/FightResults/Margin/Background/SignLost.visible = true
	$Menu/FightResults/Margin/Background/SignWin.visible = false
	$Menu/Anim.play("Move_SideBoards")
	$Arena.modulate = Color(1,1,1,1)
	$Frame.modulate = Color(1,1,1,1)
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Menu/FightResults.visible = true
	$Menu/FightResults.modulate = Color(0,0,0,1)
	$Menu/Anim.play_backwards("Move_SideBoards")
	$Menu/AnimFade.play_backwards("Fade_FightResults")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Menu/Anim.play("Move_BackBoard")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Menu/Anim.play("Move_FightAgain")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$PausePanel.pause_button_in_start_pos()
	$Arena.clear_arena()
	$Menu.show_you_lost()
	$Menu.back_button.disabled = false
	$Menu.fight_again_button.disabled = false


func on_ready_to_see_opponent_combination():
	$Arena.hide_playboard()
	$PausePanel.hide_pausebuttboard()
#	$PausePanel/Anim.play_backwards("Move_PauseButton")
	print("ready_to_see_opponent_combination")
	$Arena/Opponent.get_child(0).to_draw_sequance_of_opponent_actions()




func on_your_time_is_up():
	if $Arena/Hero.get_child(0).is_performing_action:
		print("wating")
		yield($Arena/Hero.get_child(0),"action_done")
	$Arena/Hero.get_child(0).your_time_to_prepare_sequance_is_up()
	$Arena.stop_time()
	print("mode" + str($Arena.question_board_mode))
	match $Arena.question_board_mode:
		0:
			$Arena.hide_correctboard()
			$Arena.hide_readyboard()
#			$Arena.hide_watchagainboard()
		1:
			$Arena.stop_boards_and_move_up()
			make_herose_interfaces_visible_again()
		2:
			$Arena.stop_boards_and_move_up()
			make_herose_interfaces_visible_again()
		3:
			$Arena.hide_questionboard()
			make_herose_interfaces_visible_again()



func on_your_comb_ready_before_times_up():
	var hero = $Arena/Hero.get_child(0)
	$Arena.stop_time()
	hero.your_time_to_prepare_sequance_is_up()
	$Arena.hide_correctboard()
	$Arena.hide_readyboard()
#	$Arena.hide_watchagainboard()

func on_prepare_new_combination_for_hero():
	if not $Arena/Hero.get_child(0).is_performing_action:
		var hero = $Arena/Hero.get_child(0)
		hero.start_sequance_from_beginning()

func on_start_exchange_of_hits():
	$Arena/Hero.get_child(0).start_exchange_of_hits()
	$Arena/Opponent.get_child(0).start_exchange_of_hits()
	print("_start_exchange_of_hits")

func on_arena_is_asking_a_question():
	$Arena/Hero.get_child(0).get_node("HeroInerface").visible = false
	$Arena/Opponent.get_child(0).get_node("HeroInerface").visible = false

func on_arena_stopped_asking_a_question():
	make_herose_interfaces_visible_again()

func on_player_wants_to_watch_comb_again():
	$Arena/Hero.get_child(0).cancel_your_turn()
	make_herose_interfaces_visible_again()
	$Arena/Opponent.get_child(0).load_stamina()
	$Arena/Opponent.get_child(0).show_opponent_combination()

########################
### FROM PAUSE PANEL ###
########################
func on_game_paused():
	$Arena.modulate = Color(0.5,0.5,0.5,1)
	$Frame.modulate = Color(0.5,0.5,0.5,1)

func on_game_unpaused():
	$Arena.modulate = Color(1,1,1,1)
	$Frame.modulate = Color(1,1,1,1)

func on_resign_from_fight():
	$Arena.stop_time()
	$Menu/FightResults/Margin/Background/SignLost.visible = true
	$Menu/FightResults/Margin/Background/SignWin.visible = false
	$Menu/Anim.play("Move_SideBoards")
	$Arena.modulate = Color(1,1,1,1)
	$Frame.modulate = Color(1,1,1,1)
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Menu/FightResults.visible = true
	$Menu/FightResults.modulate = Color(0,0,0,1)
	$Menu/Anim.play_backwards("Move_SideBoards")
	$Menu/AnimFade.play_backwards("Fade_FightResults")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Menu/Anim.play("Move_BackBoard")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$Menu/Anim.play("Move_FightAgain")
	if $Menu/Anim.is_playing():
		yield($Menu/Anim,"animation_finished")
	$PausePanel.pause_button_in_start_pos()
	$Arena.clear_arena()
	$Menu.show_you_lost()
	$Menu.back_button.disabled = false
	$Menu.fight_again_button.disabled = false


#################
### FROM MENU ###
#################
func on_hero_picked(hero):
	if not $Arena/Hero.get_children().empty():
		$Arena/Hero.get_child(0).queue_free()
	match hero:
		0:
			print("Gunter have been picked")
			var character = hero_package.instance()
			character.set_you_are(0)
			$Arena/Hero.add_child(character)
		1:
			print("Lenoland have been picked")
			var character = leno_package.instance()
			character.set_you_are(0)
			$Arena/Hero.add_child(character)
		2:
			print("Bloin have been picked")
			var character = bloin_package.instance()
			character.set_you_are(0)
			$Arena/Hero.add_child(character)
		3:
			print("Thog have been picked")
			var character = thog_package.instance()
			character.set_you_are(0)
			$Arena/Hero.add_child(character)


func on_prepare_opponent():
	var opponent
	if not $Arena/Opponent.get_children().empty():
		opponent = $Arena/Opponent.get_child(0)
		opponent.queue_free()
	var character = randomguy_package.instance()
	character.setup_for_opponent()
	character.set_you_are(1)
	$Arena/Opponent.add_child(character)
	character.load_stamina()
	character.load_life()

func on_prepare_your_hero():
	var hero
	if not $Arena/Hero.get_children().empty():
		hero = $Arena/Hero.get_child(0)
	hero.load_stamina()
	hero.load_life()
	hero.setup_for_you()

func on_new_fight_started():
	save_stats()
	$PausePanel.anim.play("Move_PauseButton")
	if $PausePanel.anim.is_playing():
		yield($PausePanel.anim,"animation_finished")
	$Arena.show_playboard()
	$PausePanel.show_pausebuttboard()
	if not $Menu/FightResults/Margin/Background/AddedGold.get_children().empty():
		for coin in $Menu/FightResults/Margin/Background/AddedGold.get_children():
			coin.queue_free()

#################
### FROM HERO ###
#################
func on_opponent_sequance_completed():
	$Arena/Opponent.get_child(0).opponent_back_on_position()

func on_opponent_get_back_from_showing_sequance():
	$Arena/Hero.get_child(0).your_turn_to_prepare_sequance()
	$PausePanel/Anim.play("Move_PauseButton")
	if $PausePanel/Anim.is_playing():
		yield($PausePanel/Anim,"animation_finished")



func on_your_turn():
#	$Arena.set_active_label(1)
	$Arena/Time.visible = true
	$Arena.start_your_turn()
	$Arena.show_correctboard()
	$Arena.show_readyboard()
#	$Arena.show_watchagainboard()


func on_you_prepared_your_sequance():
	$Arena.few_sec_before_start()
	$Arena/Hero.get_child(0).adjust_animations()
	$Arena/Opponent.get_child(0).adjust_animations()
	print("you_prepared_your_sequance")

var number_of_signals = 0
func on_exchange_of_hits_is_over():
	number_of_signals += 1
	if number_of_signals == 2:
		$Arena/Hero.get_child(0).end_exchange_of_hits()
		$Arena/Opponent.get_child(0).end_exchange_of_hits()
		number_of_signals = 0



func on_show_interaction(interaction_nr):
	match CurrentHero.interactions[interaction_nr]:
		0:
			print("NO INTERACTION")
			var no_interaction = no_interaction_package.instance()
			add_child(no_interaction)
			no_interaction.glob_position = Vector2(470,270)
		1:
			print("THERE WAS A BLOCK")
			var there_was_block = there_was_block_package.instance()
			add_child(there_was_block)
			there_was_block.glob_position = Vector2(470,270)
		2:
			print("HERO WAS HITTED")
			var hero_was_hitted = hero_was_hitted_package.instance()
			add_child(hero_was_hitted)
			hero_was_hitted.glob_position = Vector2(380,270)
			$Arena/Hero.get_child(0).lost_life(1)
		3:
			print("OPPONENT WAS HITTED")
			var opponent_was_hitted = opponent_was_hitted_package.instance()
			add_child(opponent_was_hitted)
			opponent_was_hitted.glob_position = Vector2(760,270)
			$Arena/Opponent.get_child(0).lost_life(1)

func on_you_can_see_another_sequance():
	$Arena.set_active_label(0)
	$Arena/Hero.get_child(0).start_sequance_from_beginning()
	$Arena/Opponent.get_child(0).start_sequance_from_beginning()
	$Arena.show_playboard()
	$PausePanel.show_pausebuttboard()


func on_one_of_the_heroes_is_dead():
	$Arena.set_active_label(5)
	$Arena/Hero.get_child(0).one_of_fighters_lost_all_life_points = true
	$Arena/Opponent.get_child(0).one_of_fighters_lost_all_life_points = true
	$Arena/Hero.get_child(0).end_exchange_of_hits()
	$Arena/Opponent.get_child(0).end_exchange_of_hits()

func on_fight_is_over():
	yield(get_tree().create_timer(2),"timeout")
	match $Arena/Hero.get_child(0).is_defeated:
		true:
			on_you_lost()
		false:
			on_you_win()


func on_show_action_description(action,who):
	var action_description = action_description_package.instance()
	action_description.setup(action,who)
	add_child(action_description)

### COMMON SIGNALS ###
func on_save_stats():
#	save_stats()
	pass


