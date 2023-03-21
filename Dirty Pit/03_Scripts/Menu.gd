extends Control

#yield(get_tree().create_timer(1),"timeout")
#yield(anim,"animation_finished")

onready var gold_container1 = $FightRank/Margin/Background/GoldContainer1
onready var gold_container2 = $FightRank/Margin/Background/GoldContainer2
onready var gold_container3 = $FightResults/Margin/Background/GoldContainer3

onready var anim = $Anim
onready var anim_fade = $AnimFade
onready var anim_take_hero = $AnimTakeHero
onready var anim_sign = $AnimSign

onready var tween = $Tween

onready var back_button = $TopDownBoards/BackBoard/Back2
onready var take_hero_button = $TakeHero/MarginContainer/Background/TakeHeroButton
onready var into_arena_button = $TopDownBoards/IntoArenaBoard/IntoTheArena
onready var start_fight_button = $TopDownBoards/StartFightBoard/StartFight
onready var fight_again_button = $TopDownBoards/FightAgain/FightAgain

onready var prog_bar1 = $HeroStats/Margin/Background/Margin/List/ProgBar1
onready var prog_bar2 = $HeroStats/Margin/Background/Margin/List/ProgBar2
onready var prog_bar3 = $HeroStats/Margin/Background/Margin/List/ProgBar3



var flying_money_package = load("res://02_Scenes/Symbols/MoneySymbol.tscn")

enum MENU_PHASE {
	TAKE_HERO,
	HERO_STATS,
	FIGHT_RANK,
	FIGHT_RESULTS,
	FIGHT_RANK_AFTER_FAIGHT_AGAIN
}
var menu_phase = MENU_PHASE.TAKE_HERO setget set_menu_phase

var number_of_heroes = 3 # Znieniaj wartość w przypadku dodania kolejnego bohatera
enum HERO_ON_SCREEN {
	GUNTER
	LENOLAND
	BLOIN
	THOG
}
var hero_on_screen = HERO_ON_SCREEN.GUNTER setget set_hero_on_screen
var is_hero_on_screen_availabe = false
var there_is_oportunity_to_rise_rank_up = false setget set_there_is_oportunity_to_rise_rank_up

var fight_rank = 1
var max_fight_rank = 1

var checking_if_fight_is_available = false
var fight_price
var fight_reward

var current_gold



func set_hero_on_screen(value):
	match value:
		0:
			hero_on_screen = HERO_ON_SCREEN.GUNTER
			is_hero_on_screen_availabe = GunterStats.available
		1:
			hero_on_screen = HERO_ON_SCREEN.LENOLAND
			is_hero_on_screen_availabe = LenolandStats.available
		2:
			hero_on_screen = HERO_ON_SCREEN.BLOIN
			is_hero_on_screen_availabe = BloinStats.available
		3:
			hero_on_screen = HERO_ON_SCREEN.THOG
			is_hero_on_screen_availabe = ThogStats.available


func set_menu_phase(value):
	match value:
		0:
			menu_phase = MENU_PHASE.TAKE_HERO
		1:
			menu_phase = MENU_PHASE.HERO_STATS
		2:
			menu_phase = MENU_PHASE.FIGHT_RANK
		3:
			menu_phase = MENU_PHASE.FIGHT_RESULTS
		4:
			menu_phase = MENU_PHASE.FIGHT_RANK_AFTER_FAIGHT_AGAIN


func set_there_is_oportunity_to_rise_rank_up(value):
	there_is_oportunity_to_rise_rank_up = value
	if there_is_oportunity_to_rise_rank_up:
		show_oportunity_of_rank_up(true)
	if not there_is_oportunity_to_rise_rank_up:
		show_oportunity_of_rank_up(false)

func _ready():
	$SideBoards.visible = true
	$SideBoards/LeftBoard1.rect_position.y = 535
	$SideBoards/RightBoard1.rect_position.y = 270
	$SideBoards.modulate = Color(0,0,0,1)
	$FightRank.modulate = Color(0,0,0,1)
	$FightRank.visible = true
	$FightResults.modulate = Color(0,0,0,1)
	$FightResults.visible = false
	$TopDownBoards.visible = true
	$TopDownBoards/StartGameBoard.visible = true
	$TopDownBoards/StartGameBoard.rect_position.x = 480
	$TopDownBoards/StartGameBoard/StartGame.disabled = false
	$TopDownBoards/QuitBoard.visible = true
	$TopDownBoards/QuitBoard.rect_position.x = 955
	$TopDownBoards/QuitBoard/Quit2.disabled = false
	$TopDownBoards/StartFightBoard.visible = true
	$TopDownBoards/StartFightBoard.rect_position.x = 0
	$TopDownBoards/IntoArenaBoard.visible = true
	$TopDownBoards/IntoArenaBoard.rect_position.x = 0
	$TopDownBoards/BackBoard.visible = true
	$TopDownBoards/BackBoard.rect_position.x = 1440
	$TopDownBoards/FightAgain.visible = true
	$TopDownBoards/FightAgain.rect_position.x = 0
	read_stats_for_hero_take()
	start_setup_for_HeroStats()
	start_setup_for_TakeHero()
	pass

func start_setup_for_HeroStats():
	$HeroStats.modulate = Color(0,0,0,1)
	$HeroStats.visible = true
	prog_bar1.start_setup(0)
	prog_bar2.start_setup(1)
	prog_bar3.start_setup(2)
	prog_bar1.get_node("RiseRankUp").visible = false
	$HeroStats/Margin/Background/Margin/List/ProgBar1/RiseRankUp/Sign2.visible = false

func start_setup_for_TakeHero():
	$TakeHero.modulate = Color(0,0,0,1)
	$TakeHero.visible = true
	$TakeHero/HeroName/Sign1.visible = true
	$TakeHero/HeroName/Sign2.visible = false
	$TakeHero/HeroName.rect_position.x = 260
	$TakeHero/MarginContainer/Background/SmallStage1/Hero1.playing = true
	$TakeHero/MarginContainer/Background/SmallStage1.rect_position = Vector2(600,0)
	$TakeHero/MarginContainer/Background/SmallStage2.rect_position = Vector2(600,500)
	$TakeHero/MarginContainer/Background/SmallStage3.rect_position = Vector2(600,500)
	$TakeHero/MarginContainer/Background/SmallStage4.rect_position = Vector2(600,500)

func show_next_hero(actual_hero_nr):
	var next_nr
	if actual_hero_nr == number_of_heroes:
		next_nr = 0
	else:
		next_nr = actual_hero_nr+1
	set_hero_on_screen(next_nr)
	var anim_to_play
	match actual_hero_nr:
		0:
			anim_to_play = "0_Hero1_to_Hero2"
		1:
			anim_to_play = "1_Hero2_to_Hero3"
		2:
			anim_to_play = "2_Hero3_to_Hero4"
		3:
			anim_to_play = "3_Hero4_to_Hero1"
	anim_take_hero.play(anim_to_play)

func show_previous_hero(actual_hero_nr):
	var previous_nr
	if actual_hero_nr == 0:
		previous_nr = number_of_heroes
	else:
		previous_nr = actual_hero_nr-1
	set_hero_on_screen(previous_nr)
	var anim_to_play
	match actual_hero_nr:
		0:
			anim_to_play = "3_Hero4_to_Hero1"
		1:
			anim_to_play = "0_Hero1_to_Hero2"
		2:
			anim_to_play = "1_Hero2_to_Hero3"
		3:
			anim_to_play = "2_Hero3_to_Hero4"
	anim_take_hero.play_backwards(anim_to_play)

func back(phase):
	match phase:
		0:
			$TakeHero/MarginContainer/Background/TakeHeroButton.disabled = true
			$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = true
			$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = true
			anim.play_backwards("Move_BackBoard")
			anim_fade.play("Fade_TakeHero")
			if anim_fade.is_playing():
				yield(anim_fade,"animation_finished")
			anim.play("Move_StartGameBoard")
		1:
			back_button.disabled = true
			into_arena_button.disabled = true
			anim.play_backwards("Move_IntoArenaBoard")
			anim_fade.play("Fade_HeroStats")
			if anim.is_playing():
				yield(anim,"animation_finished")
			anim.play_backwards("Move_BackBoard")
			if anim_fade.is_playing():
				yield(anim_fade,"animation_finished")
#			clear_life_and_stamina_symbols()
			$TakeHero.visible = true
			anim_fade.play_backwards("Fade_TakeHero")
			if anim.is_playing():
				yield(anim,"animation_finished")
			anim.play("Move_BackBoard")
			if anim.is_playing():
				yield(anim,"animation_finished")
			set_menu_phase(0)
			back_button.disabled = false
			take_hero_button.disabled = false
			$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = false
			$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = false

		2:
			back_button.disabled = true
			start_fight_button.disabled = true
			if $TopDownBoards/StartFightBoard.rect_position.x == 100:
				anim.play_backwards("Move_StartFight")
			anim_fade.play("Fade_FightRank")
			if anim.is_playing():
				yield(anim,"animation_finished")
			anim.play_backwards("Move_BackBoard")
			if anim_fade.is_playing():
				yield(anim_fade,"animation_finished")
			$HeroStats.visible = true
			anim_fade.play_backwards("Fade_HeroStats")
			if anim_fade.is_playing():
				yield(anim_fade,"animation_finished")
			anim.play("Move_IntoArenaBoard")
			if anim.is_playing():
				yield(anim,"animation_finished")
			anim.play("Move_BackBoard")
			back_button.disabled = false
			into_arena_button.disabled = false
			set_menu_phase(1)
		3:
			back_button.disabled = true
			take_hero_button.disabled = true
#			clear_life_and_stamina_symbols()
			anim_fade.play("Fade_FightResults")
			anim.play_backwards("Move_FightAgain")
			yield(anim,"animation_finished")
			anim.play_backwards("Move_BackBoard")
			if anim_fade.is_playing():
				yield(anim_fade,"animation_finished")
			$SideBoards/LeftBoard1.rect_position.y = 535
			$SideBoards/RightBoard1.rect_position.y = 270
			$SideBoards.modulate = Color(0,0,0,1)
			$TakeHero.modulate = Color(0,0,0,1)
			$TakeHero.visible = true
			$HeroStats.modulate = Color(0,0,0,1)
			$HeroStats.visible = true
			$FightRank.modulate = Color(0,0,0,1)
			$FightRank.visible = true
			$FightResults.visible = false
			anim_fade.play_backwards("Fade_TakeHero")
			if anim_fade.is_playing():
				yield(anim_fade,"animation_finished")
			anim.play("Move_BackBoard")
			if anim.is_playing():
				yield(anim,"animation_finished")
			set_menu_phase(0)
			back_button.disabled = false
			take_hero_button.disabled = false
			$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = false
			$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = false
		4:
			back_button.disabled = true
			start_fight_button.disabled = true
			anim.play_backwards("Move_StartFight")
			anim_fade.play("Fade_FightRank")
			if anim.is_playing():
				yield(anim,"animation_finished")
			anim.play_backwards("Move_BackBoard")
			if anim_fade.is_playing():
				yield(anim_fade,"animation_finished")
#			clear_life_and_stamina_symbols()
			$TakeHero.visible = true
			anim_fade.play_backwards("Fade_TakeHero")
			if anim.is_playing():
				yield(anim,"animation_finished")
			anim.play("Move_BackBoard")
			if anim.is_playing():
				yield(anim,"animation_finished")
			set_menu_phase(0)
			back_button.disabled = false
			take_hero_button.disabled = false
			$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = false
			$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = false

func _on_Quit2_button_down():
	pass # Replace with function body.
func _on_Quit2_button_up():
	get_tree().quit()

func _on_StartGame_button_down():
	pass # Replace with function body.
func _on_StartGame_button_up():
	anim.play_backwards("Move_StartGameBoard")
	anim_fade.play_backwards("Fade_TakeHero")
	if anim.is_playing():
		yield(anim,"animation_finished")
	if anim_fade.is_playing():
		yield(anim_fade,"animation_finished")
	$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = false
	$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = false
	anim.play("Move_BackBoard")
	if anim.is_playing():
		yield(anim,"animation_finished")
	take_hero_button.disabled = false
	back_button.disabled = false

func _on_Back2_button_down():
	pass # Replace with function body.
func _on_Back2_button_up():
	back(menu_phase)

func _on_PreviousHero_button_down():
	$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.modulate = Color(0,0,0,1)
func _on_PreviousHero_button_up():
	$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.modulate = Color(1,1,1,1)
	$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = true
	take_hero_button.disabled = true
	if anim_take_hero.is_playing():
		yield(anim_take_hero,"animation_finished")
		$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = false
		return
	anim_sign.play_backwards("HeroName")
	show_previous_hero(hero_on_screen)
	if anim_sign.is_playing():
		yield(anim_sign,"animation_finished")
	match hero_on_screen:
		0:
			$TakeHero/HeroName/Sign1.visible = true
			$TakeHero/HeroName/Sign2.visible = false
			$TakeHero/HeroName/Sign3.visible = false
			$TakeHero/HeroName/Sign4.visible = false
		1:
			$TakeHero/HeroName/Sign1.visible = false
			$TakeHero/HeroName/Sign2.visible = true
			$TakeHero/HeroName/Sign3.visible = false
			$TakeHero/HeroName/Sign4.visible = false
		2:
			$TakeHero/HeroName/Sign1.visible = false
			$TakeHero/HeroName/Sign2.visible = false
			$TakeHero/HeroName/Sign3.visible = true
			$TakeHero/HeroName/Sign4.visible = false
		3:
			$TakeHero/HeroName/Sign1.visible = false
			$TakeHero/HeroName/Sign2.visible = false
			$TakeHero/HeroName/Sign3.visible = false
			$TakeHero/HeroName/Sign4.visible = true
	anim_sign.play("HeroName")
	$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = false
	if anim_take_hero.is_playing():
		yield(anim_take_hero,"animation_finished")
	take_hero_button.disabled = false


func _on_NextHero_button_down():
	$TakeHero/MarginContainer/Background/RightLeft/NextHero.modulate = Color(0,0,0,1)
func _on_NextHero_button_up():
	$TakeHero/MarginContainer/Background/RightLeft/NextHero.modulate = Color(1,1,1,1)
	$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = true
	take_hero_button.disabled = true
	if anim_take_hero.is_playing():
		yield(anim_take_hero,"animation_finished")
		$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = false
		return
	anim_sign.play_backwards("HeroName")
	show_next_hero(hero_on_screen)
	if anim_sign.is_playing():
		yield(anim_sign,"animation_finished")
	match hero_on_screen:
		0:
			$TakeHero/HeroName/Sign1.visible = true
			$TakeHero/HeroName/Sign2.visible = false
			$TakeHero/HeroName/Sign3.visible = false
			$TakeHero/HeroName/Sign4.visible = false
		1:
			$TakeHero/HeroName/Sign1.visible = false
			$TakeHero/HeroName/Sign2.visible = true
			$TakeHero/HeroName/Sign3.visible = false
			$TakeHero/HeroName/Sign4.visible = false
		2:
			$TakeHero/HeroName/Sign1.visible = false
			$TakeHero/HeroName/Sign2.visible = false
			$TakeHero/HeroName/Sign3.visible = true
			$TakeHero/HeroName/Sign4.visible = false
		3:
			$TakeHero/HeroName/Sign1.visible = false
			$TakeHero/HeroName/Sign2.visible = false
			$TakeHero/HeroName/Sign3.visible = false
			$TakeHero/HeroName/Sign4.visible = true
	anim_sign.play("HeroName")
	$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = false
	if anim_take_hero.is_playing():
		yield(anim_take_hero,"animation_finished")
	take_hero_button.disabled = false

func _on_TakeHeroButton_button_down():
	pass # Replace with function body.
func _on_TakeHeroButton_button_up():

	match is_hero_on_screen_availabe:
		true:
			$TakeHero/MarginContainer/Background/RightLeft/NextHero.disabled = true
			$TakeHero/MarginContainer/Background/RightLeft/PreviousHero.disabled = true
			back_button.disabled = true
			take_hero_button.disabled = true

			match hero_on_screen:
				0:
					read_Gunter_stats()
					CurrentHero.set_current_hero("Gunter")
				1:
					read_Lenoland_stats()
					CurrentHero.set_current_hero("Lenoland")
				2:
					read_Bloin_stats()
					CurrentHero.set_current_hero("Bloin")
				3:
					read_Thog_stats()
					CurrentHero.set_current_hero("Thog")


			GlobalSignals.emit_signal("_hero_picked",hero_on_screen)
			anim.play_backwards("Move_BackBoard")
			anim_fade.play("Fade_TakeHero")
			yield(anim_fade,"animation_finished")
			$TakeHero.visible = false
			$HeroStats.visible = true
			anim_fade.play_backwards("Fade_HeroStats")
			anim.play("Move_BackBoard")
			set_menu_phase(1)
			yield(anim,"animation_finished")
			anim.play("Move_IntoArenaBoard")
			back_button.disabled = false
			into_arena_button.disabled = false
		false:
			return

func _on_IntoTheArena_button_down():
	pass # Replace with function body.
func _on_IntoTheArena_button_up():
	$FightRank/Margin/Background/RankBut/RankDown.disabled = false
	$FightRank/Margin/Background/RankBut/RankUp.disabled = false
	back_button.disabled = true
	into_arena_button.disabled = true
	anim.play_backwards("Move_BackBoard")
	yield(anim,"animation_finished")
	anim.play_backwards("Move_IntoArenaBoard")
	anim_fade.play("Fade_HeroStats")
	yield(anim_fade,"animation_finished")
	$HeroStats.visible = false
	anim_fade.play_backwards("Fade_FightRank")
	anim.play("Move_BackBoard")
	set_menu_phase(2)
	yield(anim,"animation_finished")
	check_if_fight_is_available()
	yield(get_tree().create_timer(1),"timeout")
	back_button.disabled = false


func _on_StartFight_button_down():
	pass # Replace with function body.
func _on_StartFight_button_up():
	GlobalSignals.emit_signal("_prepare_opponent")
	GlobalSignals.emit_signal("_prepare_your_hero")

	$FightRank/Margin/Background/RankBut/RankDown.disabled = true
	$FightRank/Margin/Background/RankBut/RankUp.disabled = true
	#### TAKE DAPOSIT ####
	match hero_on_screen:
		0:
			GunterStats.gold -= int(fight_price)
		1:
			LenolandStats.gold -= int(fight_price)
		2:
			BloinStats.gold -= int(fight_price)
		3:
			ThogStats.gold -= int(fight_price)
	back_button.disabled = true
	start_fight_button.disabled = true
	anim.play_backwards("Move_BackBoard")
	anim_fade.play("Fade_FightRank")
	yield(anim,"animation_finished")
	anim.play_backwards("Move_StartFight")
	if anim_fade.is_playing():
		yield(anim_fade,"animation_finished")
	$FightResults.visible = false
	$FightRank.visible = false
	$HeroStats.visible = false
	$TakeHero.visible = false
	anim_fade.play_backwards("Fade_SideBoards")
	if anim_fade.is_playing():
		yield(anim_fade,"animation_finished")
	anim.play_backwards("Move_SideBoards")
	if anim.is_playing():
		yield(anim,"animation_finished")
	GlobalSignals.emit_signal("_new_fight_started")
	set_menu_phase(3)

func _on_FightAgain_button_down():
	pass # Replace with function body.
func _on_FightAgain_button_up():
	$FightRank/Margin/Background/RankBut/RankDown.disabled = false
	$FightRank/Margin/Background/RankBut/RankUp.disabled = false
	GlobalSignals.emit_signal("_hero_picked",hero_on_screen)
	back_button.disabled = true
	fight_again_button.disabled = true
	anim.play_backwards("Move_BackBoard")
	yield(anim,"animation_finished")
	anim.play_backwards("Move_FightAgain")
	yield(anim,"animation_finished")
	anim_fade.play("Fade_FightResults")
	yield(anim_fade,"animation_finished")
	$SideBoards/LeftBoard1.rect_position.y = 535
	$SideBoards/RightBoard1.rect_position.y = 270
	$SideBoards.modulate = Color(0,0,0,1)
#	$TakeHero.modulate = Color(0,0,0,1)
#	$TakeHero.visible = true
#	$HeroStats.modulate = Color(0,0,0,1)
#	$HeroStats.visible = true
	$FightRank.modulate = Color(0,0,0,1)
	$FightRank.visible = true
	$FightResults.visible = false
	anim_fade.play_backwards("Fade_FightRank")
	set_menu_phase(4)
	check_if_fight_is_available()
	if anim.is_playing():
		yield(anim,"animation_finished")
	anim.play("Move_BackBoard")
	if anim.is_playing():
		yield(anim,"animation_finished")
	back_button.disabled = false

#func clear_life_and_stamina_symbols():
#	var short_1 = $HeroStats/Margin/Background/Margin/List/Life.get_children()
#	var short_2 = $HeroStats/Margin/Background/Margin/List/Stamina.get_children()
#	for child in short_1:
#		if not child.name == "LifeLabel":
#			child.queue_free()
#	for child in short_2:
#		if not child.name == "StaminaLabel":
#			child.queue_free()

func read_stats_for_hero_take():

	# for Gunter 
	var rank_in_str = str(GunterStats.rank)
	var short = $HeroStats/Margin/Background/Margin/List/CRankImage/Sign
	short = $TakeHero/MarginContainer/Background/SmallStage1/Sign
	short.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
	if GunterStats.rank>= 10:
		short.get_node("NUMBER2").texture=Numbers.take_number(rank_in_str[1])
		short.get_node("NUMBER2").visible = true
	else:
		short.get_node("NUMBER2").visible = false

	# for Lenoland
	rank_in_str = str(LenolandStats.rank)
	short = $HeroStats/Margin/Background/Margin/List/CRankImage/Sign
	short = $TakeHero/MarginContainer/Background/SmallStage2/Sign
	short.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
	if LenolandStats.rank>= 10:
		short.get_node("NUMBER2").texture=Numbers.take_number(rank_in_str[1])
		short.get_node("NUMBER2").visible = true
	else:
		short.get_node("NUMBER2").visible = false

	# for Bloin
	rank_in_str = str(BloinStats.rank)
	short = $HeroStats/Margin/Background/Margin/List/CRankImage/Sign
	short = $TakeHero/MarginContainer/Background/SmallStage3/Sign
	short.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
	if BloinStats.rank>= 10:
		short.get_node("NUMBER2").texture=Numbers.take_number(rank_in_str[1])
		short.get_node("NUMBER2").visible = true
	else:
		short.get_node("NUMBER2").visible = false

	# for Thog
	rank_in_str = str(ThogStats.rank)
	short = $HeroStats/Margin/Background/Margin/List/CRankImage/Sign
	short = $TakeHero/MarginContainer/Background/SmallStage3/Sign
	short.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
	if ThogStats.rank>= 10:
		short.get_node("NUMBER2").texture=Numbers.take_number(rank_in_str[1])
		short.get_node("NUMBER2").visible = true
	else:
		short.get_node("NUMBER2").visible = false


func read_Gunter_stats():
	var _life_symbol
	var stamina_symbol
	var short_for_stats = $HeroStats/Margin/Background/Margin/List
	update_won_fights_in_herostats(GunterStats.won_fights)
	short_for_stats.get_node("ProgBar1").set_number_of_spaces(GunterStats.top_border_of_next_rank)
	short_for_stats.get_node("ProgBar1").set_filed_spaces(GunterStats.gained_experiance)
	short_for_stats.get_node("ProgBar2").set_number_of_spaces(GunterStats.life_points)
	short_for_stats.get_node("ProgBar3").set_number_of_spaces(GunterStats.stamina_points)
	update_available_gold(GunterStats.gold)
	update_gold_in_fightsresult(GunterStats.gold)
	check_if_rise_rank_up_is_availabe("Gunter")
	max_fight_rank = GunterStats.rank
	fight_rank = GunterStats.rank
	update_rank_in_fightrank_and_fightresults(GunterStats.rank)
	price_and_reward(GunterStats.rank)
	update_ranksign_in_hero_stats(GunterStats.rank)

func read_Lenoland_stats():
	var life_symbol
	var stamina_symbol
	var short_for_stats = $HeroStats/Margin/Background/Margin/List
	update_won_fights_in_herostats(LenolandStats.won_fights)
	short_for_stats.get_node("ProgBar1").set_number_of_spaces( LenolandStats.top_border_of_next_rank)
	short_for_stats.get_node("ProgBar1").set_filed_spaces( LenolandStats.gained_experiance)
	short_for_stats.get_node("ProgBar2").set_number_of_spaces( LenolandStats.life_points)
	short_for_stats.get_node("ProgBar3").set_number_of_spaces( LenolandStats.stamina_points)
	update_available_gold(LenolandStats.gold)
	update_gold_in_fightsresult(LenolandStats.gold)
	check_if_rise_rank_up_is_availabe("Lenoland")
	max_fight_rank = LenolandStats.rank
	fight_rank = LenolandStats.rank
	update_rank_in_fightrank_and_fightresults(LenolandStats.rank)
	price_and_reward(LenolandStats.rank)
	update_ranksign_in_hero_stats(LenolandStats.rank)

func read_Bloin_stats():
	var life_symbol
	var stamina_symbol
	var short_for_stats = $HeroStats/Margin/Background/Margin/List
	update_won_fights_in_herostats(BloinStats.won_fights)
	short_for_stats.get_node("ProgBar1").set_number_of_spaces( BloinStats.top_border_of_next_rank)
	short_for_stats.get_node("ProgBar1").set_filed_spaces( BloinStats.gained_experiance)
	short_for_stats.get_node("ProgBar2").set_number_of_spaces( BloinStats.life_points)
	short_for_stats.get_node("ProgBar3").set_number_of_spaces( BloinStats.stamina_points)
	update_available_gold(BloinStats.gold)
	update_gold_in_fightsresult(BloinStats.gold)
	check_if_rise_rank_up_is_availabe("Bloin")
	max_fight_rank = BloinStats.rank
	fight_rank = BloinStats.rank
	update_rank_in_fightrank_and_fightresults(BloinStats.rank)
	price_and_reward(BloinStats.rank)
	update_ranksign_in_hero_stats(BloinStats.rank)

func read_Thog_stats():
	var life_symbol
	var stamina_symbol
	var short_for_stats = $HeroStats/Margin/Background/Margin/List
	update_won_fights_in_herostats(ThogStats.won_fights)
	short_for_stats.get_node("ProgBar1").set_number_of_spaces( ThogStats.top_border_of_next_rank)
	short_for_stats.get_node("ProgBar1").set_filed_spaces( ThogStats.gained_experiance)
	short_for_stats.get_node("ProgBar2").set_number_of_spaces( ThogStats.life_points)
	short_for_stats.get_node("ProgBar3").set_number_of_spaces( ThogStats.stamina_points)
	update_available_gold(ThogStats.gold)
	update_gold_in_fightsresult(ThogStats.gold)
	check_if_rise_rank_up_is_availabe("Thog")
	max_fight_rank = ThogStats.rank
	fight_rank = ThogStats.rank
	update_rank_in_fightrank_and_fightresults(ThogStats.rank)
	price_and_reward(ThogStats.rank)
	update_ranksign_in_hero_stats(ThogStats.rank)



func price_and_reward(rank):
	var short_for_price_nr = $FightRank/Margin/Background/PriceAmount
	var short_for_reward_nr = $FightRank/Margin/Background/RewardAmount
	var price_in_str
	var reward_in_str
	if rank >= 1:
		price_in_str = str(CurrentHero.gold_price_rank_multiplier*rank)
		fight_price = CurrentHero.gold_price_rank_multiplier*rank
		reward_in_str = str(CurrentHero.gold_reward_rank_multiplier*rank)
		fight_reward = CurrentHero.gold_reward_rank_multiplier*rank
	if rank ==0:
		price_in_str = str(0)
		fight_price = 0
		reward_in_str = str(1)
		fight_reward = 5


	gold_container1.show_gold(fight_reward)
	gold_container2.show_gold(fight_price)
	gold_container3.show_gold(current_gold)

	update_rank_in_fightrank_and_fightresults(rank)
	if price_in_str.length() >= 5:
		return
	if price_in_str.length() == 4:
		short_for_price_nr.get_node("NUMBER1").texture=Numbers.take_number(price_in_str[0])
		short_for_price_nr.get_node("NUMBER2").texture=Numbers.take_number(price_in_str[1])
		short_for_price_nr.get_node("NUMBER3").texture=Numbers.take_number(price_in_str[2])
		short_for_price_nr.get_node("NUMBER4").texture=Numbers.take_number(price_in_str[3])
		short_for_price_nr.get_node("NUMBER2").visible = true
		short_for_price_nr.get_node("NUMBER3").visible = true
		short_for_price_nr.get_node("NUMBER4").visible = true
	elif price_in_str.length() == 3:
		short_for_price_nr.get_node("NUMBER1").texture=Numbers.take_number(price_in_str[0])
		short_for_price_nr.get_node("NUMBER2").texture=Numbers.take_number(price_in_str[1])
		short_for_price_nr.get_node("NUMBER3").texture=Numbers.take_number(price_in_str[2])
		short_for_price_nr.get_node("NUMBER2").visible = true
		short_for_price_nr.get_node("NUMBER3").visible = true
		short_for_price_nr.get_node("NUMBER4").visible = false
	elif price_in_str.length() == 2:
		short_for_price_nr.get_node("NUMBER1").texture=Numbers.take_number(price_in_str[0])
		short_for_price_nr.get_node("NUMBER2").texture=Numbers.take_number(price_in_str[1])
		short_for_price_nr.get_node("NUMBER2").visible = true
		short_for_price_nr.get_node("NUMBER3").visible = false
		short_for_price_nr.get_node("NUMBER4").visible = false
	else:
		short_for_price_nr.get_node("NUMBER1").texture=Numbers.take_number(price_in_str[0])
		short_for_price_nr.get_node("NUMBER2").visible = false
		short_for_price_nr.get_node("NUMBER3").visible = false
		short_for_price_nr.get_node("NUMBER4").visible = false
	
	if reward_in_str.length() >= 5:
		return
	if reward_in_str.length()== 4:
		short_for_reward_nr.get_node("NUMBER1").texture=Numbers.take_number(reward_in_str[0])
		short_for_reward_nr.get_node("NUMBER2").texture=Numbers.take_number(reward_in_str[1])
		short_for_reward_nr.get_node("NUMBER3").texture=Numbers.take_number(reward_in_str[2])
		short_for_reward_nr.get_node("NUMBER4").texture=Numbers.take_number(reward_in_str[3])
		short_for_reward_nr.get_node("NUMBER2").visible = true
		short_for_reward_nr.get_node("NUMBER3").visible = true
		short_for_reward_nr.get_node("NUMBER4").visible = true
	elif reward_in_str.length()== 3:
		short_for_reward_nr.get_node("NUMBER1").texture=Numbers.take_number(reward_in_str[0])
		short_for_reward_nr.get_node("NUMBER2").texture=Numbers.take_number(reward_in_str[1])
		short_for_reward_nr.get_node("NUMBER3").texture=Numbers.take_number(reward_in_str[2])
		short_for_reward_nr.get_node("NUMBER2").visible = true
		short_for_reward_nr.get_node("NUMBER3").visible = true
		short_for_reward_nr.get_node("NUMBER4").visible = false
	elif reward_in_str.length()== 2:
		short_for_reward_nr.get_node("NUMBER1").texture=Numbers.take_number(reward_in_str[0])
		short_for_reward_nr.get_node("NUMBER2").texture=Numbers.take_number(reward_in_str[1])
		short_for_reward_nr.get_node("NUMBER2").visible = true
		short_for_reward_nr.get_node("NUMBER3").visible = false
		short_for_reward_nr.get_node("NUMBER4").visible = false
	else:
		short_for_reward_nr.get_node("NUMBER1").texture=Numbers.take_number(reward_in_str[0])
		short_for_reward_nr.get_node("NUMBER2").visible = false
		short_for_reward_nr.get_node("NUMBER3").visible = false
		short_for_reward_nr.get_node("NUMBER4").visible = false



func _on_RankDown_button_down():
	$FightRank/Margin/Background/RankBut/RankDown.modulate = Color(0,0,0,1)
func _on_RankDown_button_up():
	if not checking_if_fight_is_available:
		if fight_rank >= 1 :
			fight_rank -= 1
			price_and_reward(fight_rank)
		$FightRank/Margin/Background/RankBut/RankDown.modulate = Color(1,1,1,1)
	check_if_fight_is_available()

func _on_RankUp_button_down():
	$FightRank/Margin/Background/RankBut/RankUp.modulate = Color(0,0,0,1)
func _on_RankUp_button_up():
	if not checking_if_fight_is_available:
#		var short_for_stats = $HeroStats/Margin/Background/Margin/List
		var max_rank = max_fight_rank
		if fight_rank < max_rank :
			fight_rank += 1
			price_and_reward(fight_rank)
		$FightRank/Margin/Background/RankBut/RankUp.modulate = Color(1,1,1,1)
	check_if_fight_is_available()

func check_if_fight_is_available():
	checking_if_fight_is_available = true

	var current_rank = max_fight_rank
	if $TopDownBoards/StartFightBoard.rect_position.x==0:
		if current_gold >= fight_price:
			back_button.disabled = true
			anim.play("Move_StartFight")
			yield(anim,"animation_finished")
			start_fight_button.disabled = false
			back_button.disabled = false
	if $TopDownBoards/StartFightBoard.rect_position.x==100:
		if current_gold < fight_price:
			back_button.disabled = true
			start_fight_button.disabled = true
			anim.play_backwards("Move_StartFight")
			yield(anim,"animation_finished")
			back_button.disabled = false
	checking_if_fight_is_available = false

func show_you_lost():
	print(fight_price)
	print(current_gold)
	var gold_after_fight = current_gold - int(fight_price)
	
	if fight_price !=0:
		for i in range(CurrentHero.gold_intervals(fight_price)):
			$FightResults/Margin/Background/GoldContainer3.visible_coins[-1-i].fly_out()


	match hero_on_screen:
		0:
			GunterStats.gold = gold_after_fight
		1:
			LenolandStats.gold = gold_after_fight
		2:
			BloinStats.gold = gold_after_fight
		3:
			ThogStats.gold = gold_after_fight
	update_available_gold(gold_after_fight)
	update_gold_in_fightsresult(gold_after_fight)
	GlobalSignals.emit_signal("_save_stats")

func show_you_win():
	print("you win")
	print(fight_reward)
	print(current_gold)
	var gold_after_fight = current_gold + int(fight_reward)

#	var money_away = flying_money_package.instance()
#	money_away.setup(fight_reward,"DOWN")
#	get_parent().add_child(money_away)
#	money_away.position = Vector2(320,270)

	for i in range(CurrentHero.gold_intervals(fight_reward)):
		var money_in = flying_money_package.instance()
		money_in.start_set_up(Vector2(250,270))
		$FightResults/Margin/Background/AddedGold.add_child(money_in)


	match hero_on_screen:
		0:
			GunterStats.gold = gold_after_fight
			check_if_new_rank_available("Gunter")
			
		1:
			LenolandStats.gold = gold_after_fight
			check_if_new_rank_available("Lenoland")
		2:
			BloinStats.gold = gold_after_fight
			check_if_new_rank_available("Bloin")
		3:
			ThogStats.gold = gold_after_fight
			check_if_new_rank_available("Thog")
	update_available_gold(gold_after_fight)
	update_gold_in_fightsresult(gold_after_fight)
	GlobalSignals.emit_signal("_save_stats")

func check_if_new_rank_available(name):
	var short = get_tree().root.get_node(name + "Stats") 
	short.won_fights += 1 
	if not short.gained_experiance == short.top_border_of_next_rank:
		short.gained_experiance += 1
		update_progbar1_in_herostats(short.gained_experiance)
	update_won_fights_in_herostats(short.won_fights)
	check_if_rise_rank_up_is_availabe(name)


func show_oportunity_of_rank_up(value:bool):
	if value:
		$HeroStats/Margin/Background/Margin/List/ProgBar1/RiseRankUp.visible = true
		$HeroStats/Margin/Background/Margin/List/ProgBar1/RiseRankUp.disabled = false
		$HeroStats/Margin/Background/Margin/List/ProgBar1/RiseRankUp/Sign/RankAnim.play("RankAnim")
	if not value:
		$HeroStats/Margin/Background/Margin/List/ProgBar1/RiseRankUp.visible = false
		$HeroStats/Margin/Background/Margin/List/ProgBar1/RiseRankUp.disabled = true
		$HeroStats/Margin/Background/Margin/List/ProgBar1/RiseRankUp/Sign/RankAnim.stop()

func _on_RiseRankUp_pressed():
	var short = get_tree().root.get_node(CurrentHero.current_hero + "Stats")
	var price = CurrentHero.price_for_rise_rank_up(short.rank)
	if price <= short.gold:
		rise_your_rank(short)
		prog_bar1.get_node("RiseRankUp/Sign/RankAnim").stop()
		prog_bar1.get_node("RiseRankUp/Sign").visible = false
		prog_bar1.get_node("RiseRankUp").disabled = true
	else:
		prog_bar1.get_node("RiseRankUp/Sign/RankAnim").stop()
		prog_bar1.get_node("RiseRankUp/Sign").visible = false
		var price_in_str = str(price)
		if price < 100:
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER1").texture=Numbers.take_number(price_in_str[0])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER2").texture=Numbers.take_number(price_in_str[1])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER3").visible = false
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER4").visible = false
		elif price < 1000:
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER1").texture=Numbers.take_number(price_in_str[0])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER2").texture=Numbers.take_number(price_in_str[1])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER3").texture=Numbers.take_number(price_in_str[2])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER3").visible = true
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER4").visible = false
		elif price < 10000:
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER1").texture=Numbers.take_number(price_in_str[0])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER2").texture=Numbers.take_number(price_in_str[1])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER3").texture=Numbers.take_number(price_in_str[2])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER4").texture=Numbers.take_number(price_in_str[3])
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER3").visible = true
			prog_bar1.get_node("RiseRankUp/Sign2/NUMBER4").visible = true

		prog_bar1.get_node("RiseRankUp/Sign2").visible = true
		
		tween.interpolate_property(prog_bar1.get_node("RiseRankUp/Sign2"), "modulate",
Color(0,0,0,1),Color(0,0,0,0), 1,
Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween,"tween_completed")
		prog_bar1.get_node("RiseRankUp/Sign2").visible = false
		prog_bar1.get_node("RiseRankUp/Sign2").modulate = Color(0,0,0,1)
		prog_bar1.get_node("RiseRankUp/Sign/RankAnim").play("RankAnim")
		prog_bar1.get_node("RiseRankUp/Sign").visible = true



func rise_your_rank(name):
	var short = name
	short.gold -= CurrentHero.price_for_rise_rank_up(short.rank)
	update_available_gold(short.gold)
	short.rank += 1
	short.gained_experiance = 0
	max_fight_rank = short.rank
	short.create_new_top_border_of_next_rank()
	check_if_blocked_hero_is_now_available(name,short.rank)
	update_other_stats(short.rank)


func update_gold_in_fightsresult(gold):
	var gold_in_str = str(gold)
	var short = $FightResults/Margin/Background/GoldAfter
	if gold>= 99999:
		return
	if gold>= 10000:
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(gold_in_str[1])
		short.get_node("NUMBER3").texture=Numbers.take_number(gold_in_str[2])
		short.get_node("NUMBER4").texture=Numbers.take_number(gold_in_str[3])
		short.get_node("NUMBER4").texture=Numbers.take_number(gold_in_str[4])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = true
		short.get_node("NUMBER4").visible = true
		short.get_node("NUMBER5").visible = true
	if gold>= 1000:
		print("wielkie grzybobranie")
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(gold_in_str[1])
		short.get_node("NUMBER3").texture=Numbers.take_number(gold_in_str[2])
		short.get_node("NUMBER4").texture=Numbers.take_number(gold_in_str[3])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = true
		short.get_node("NUMBER4").visible = true
		short.get_node("NUMBER5").visible = false
	elif gold>= 100:
		print("hakuna mamtata")
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(gold_in_str[1])
		short.get_node("NUMBER3").texture=Numbers.take_number(gold_in_str[2])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = true
		short.get_node("NUMBER4").visible = false
		short.get_node("NUMBER5").visible = false
	elif gold>= 10:
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(gold_in_str[1])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = false
		short.get_node("NUMBER4").visible = false
		short.get_node("NUMBER5").visible = false
	else:
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").visible = false
		short.get_node("NUMBER3").visible = false
		short.get_node("NUMBER4").visible = false
		short.get_node("NUMBER5").visible = false


func update_available_gold(gold):
	var gold_in_str = str(gold)
	var short = $HeroStats/Margin/Background/Margin/List/ListOfGandWF/Gold/Sign2
	if gold>= 99999:
		return
	if gold>= 10000:
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(gold_in_str[1])
		short.get_node("NUMBER3").texture=Numbers.take_number(gold_in_str[2])
		short.get_node("NUMBER4").texture=Numbers.take_number(gold_in_str[3])
		short.get_node("NUMBER4").texture=Numbers.take_number(gold_in_str[4])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = true
		short.get_node("NUMBER4").visible = true
		short.get_node("NUMBER5").visible = true
	if gold>= 1000:
		print("wielkie grzybobranie")
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(gold_in_str[1])
		short.get_node("NUMBER3").texture=Numbers.take_number(gold_in_str[2])
		short.get_node("NUMBER4").texture=Numbers.take_number(gold_in_str[3])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = true
		short.get_node("NUMBER4").visible = true
		short.get_node("NUMBER5").visible = false
	elif gold>= 100:
		print("hakuna mamtata")
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(gold_in_str[1])
		short.get_node("NUMBER3").texture=Numbers.take_number(gold_in_str[2])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = true
		short.get_node("NUMBER4").visible = false
		short.get_node("NUMBER5").visible = false
	elif gold>= 10:
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(gold_in_str[1])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = false
		short.get_node("NUMBER4").visible = false
		short.get_node("NUMBER5").visible = false
	else:
		short.get_node("NUMBER1").texture=Numbers.take_number(gold_in_str[0])
		short.get_node("NUMBER2").visible = false
		short.get_node("NUMBER3").visible = false
		short.get_node("NUMBER4").visible = false
		short.get_node("NUMBER5").visible = false

	current_gold = gold

func update_rank_in_fightrank_and_fightresults(rank):
	var short = $FightRank/Margin/Background/RankNumber
	var short2 = $FightResults/Margin/Background/RankNumber
	var rank_in_str = str(rank)
	if rank>= 100:
		return
	if rank>= 10:
		short.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(rank_in_str[1])
		short.get_node("NUMBER2").visible = true
		short2.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
		short2.get_node("NUMBER2").texture=Numbers.take_number(rank_in_str[1])
		short2.get_node("NUMBER2").visible = true
	else:
		short.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
		short.get_node("NUMBER2").visible = false
		short2.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
		short2.get_node("NUMBER2").visible = false


func update_progbar1_in_herostats(gained_experiance):
	prog_bar1.set_filed_spaces(gained_experiance)

func update_won_fights_in_herostats(won_fights):
	var won_fights_in_str = str(won_fights)
	var short = $HeroStats/Margin/Background/Margin/List/ListOfGandWF/WonFights/Sign2
	if won_fights>= 10000:
		return
	if won_fights>= 1000:
		short.get_node("NUMBER1").texture=Numbers.take_number(won_fights_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(won_fights_in_str[1])
		short.get_node("NUMBER3").texture=Numbers.take_number(won_fights_in_str[2])
		short.get_node("NUMBER4").texture=Numbers.take_number(won_fights_in_str[3])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = true
		short.get_node("NUMBER4").visible = true
	elif won_fights>= 100:
		short.get_node("NUMBER1").texture=Numbers.take_number(won_fights_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(won_fights_in_str[1])
		short.get_node("NUMBER3").texture=Numbers.take_number(won_fights_in_str[2])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = true
		short.get_node("NUMBER4").visible = false
	elif won_fights>= 10:
		short.get_node("NUMBER1").texture=Numbers.take_number(won_fights_in_str[0])
		short.get_node("NUMBER2").texture=Numbers.take_number(won_fights_in_str[1])
		short.get_node("NUMBER2").visible = true
		short.get_node("NUMBER3").visible = false
		short.get_node("NUMBER4").visible = false
	else:
		short.get_node("NUMBER1").texture=Numbers.take_number(won_fights_in_str[0])
		short.get_node("NUMBER2").visible = false
		short.get_node("NUMBER3").visible = false
		short.get_node("NUMBER4").visible = false


func update_ranksign_in_hero_stats(rank):
	var rank_in_str = str(rank)
	var short = $HeroStats/Margin/Background/Margin/List/CRankImage/Sign

	short.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
	if rank>= 10:
		short.get_node("NUMBER2").texture=Numbers.take_number(rank_in_str[1])
		short.get_node("NUMBER2").visible = true
	else:
		short.get_node("NUMBER2").visible = false


func update_ranksign_in_take_hero(rank):
	var rank_in_str = str(rank)
	var short = $HeroStats/Margin/Background/Margin/List/CRankImage/Sign
	match hero_on_screen:
		0:
			short = $TakeHero/MarginContainer/Background/SmallStage1/Sign
		1:
			short = $TakeHero/MarginContainer/Background/SmallStage2/Sign
		2:
			short = $TakeHero/MarginContainer/Background/SmallStage3/Sign
		3:
			short = $TakeHero/MarginContainer/Background/SmallStage4/Sign
			
	short.get_node("NUMBER1").texture=Numbers.take_number(rank_in_str[0])
	if rank>= 10:
		short.get_node("NUMBER2").texture=Numbers.take_number(rank_in_str[1])
		short.get_node("NUMBER2").visible = true
	else:
		short.get_node("NUMBER2").visible = false


func update_other_stats(rank):
	update_ranksign_in_take_hero(rank)
	update_ranksign_in_hero_stats(rank)
	
	match hero_on_screen:
		0:
			GunterStats.update_stats()
			prog_bar1.set_number_of_spaces(GunterStats.rank)
			prog_bar1.set_filed_spaces(0)
			prog_bar2.set_number_of_spaces(GunterStats.life_points)
			prog_bar3.set_number_of_spaces(GunterStats.stamina_points)
		1:
			LenolandStats.update_stats()
			prog_bar1.set_number_of_spaces(LenolandStats.rank)
			prog_bar1.set_filed_spaces(0)
			prog_bar2.set_number_of_spaces(LenolandStats.life_points)
			prog_bar3.set_number_of_spaces(LenolandStats.stamina_points)
		2:
			BloinStats.update_stats()
			prog_bar1.set_number_of_spaces(BloinStats.rank)
			prog_bar1.set_filed_spaces(0)
			prog_bar2.set_number_of_spaces(BloinStats.life_points)
			prog_bar3.set_number_of_spaces(BloinStats.stamina_points)
		3:
			ThogStats.update_stats()
			prog_bar1.set_number_of_spaces(ThogStats.rank)
			prog_bar1.set_filed_spaces(0)
			prog_bar2.set_number_of_spaces(ThogStats.life_points)
			prog_bar3.set_number_of_spaces(ThogStats.stamina_points)

func check_if_rise_rank_up_is_availabe(name):
	var short = get_tree().root.get_node(name + "Stats") 
	if short.gained_experiance == short.top_border_of_next_rank:
		set_there_is_oportunity_to_rise_rank_up(true)

func check_if_blocked_hero_is_now_available(name,rank):
		match name.name:
			"GunterStats":
				if rank == 2:
					LenolandStats.available = true
					GlobalSignals.emit_signal("_load_hero_availability")
			"LenolandStats":
				if rank == 2:
					BloinStats.available = true
					GlobalSignals.emit_signal("_load_hero_availability")
			"BloinStats":
				if rank == 2:
					ThogStats.available = true
					GlobalSignals.emit_signal("_load_hero_availability")
