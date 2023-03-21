extends Node

#Z indexes:
# 50 - FadeAllNode
# 11 - SettingsNode
# 10 - Choose snake active buttons 
# 9 - Choose snake not active buttons   


onready var world := $World
onready var player = $Player
var map_size = Vector2.ZERO
export var wait_before_snake_start = 3
export var start_orientation = Vector2(1,0)
export var start_pos = Vector2(1000,500)

func _input(event):
	if event is InputEventKey and event.scancode==KEY_SPACE:
		if event.is_pressed() and not event.is_echo():
			print("space is working")


func bb_test():
#	$ChooseSnake/SnakesButtons/Snake2/Snake2/VBox1/HBox4/TextureRect/Margin/Sign.bb_change_container_width(800,500,1)
	$ChooseSnake/SnakesButtons/Snake2/Snake2/VBox1/HBox4/TextureRect/Margin/Sign.bb_change_container_scale(Vector2(1,1),Vector2(0.7,0.7),1)


func _ready():
	$ChooseSnake.visible = true
	$SettingsNode.visible = false
	randomize()
#	start_pos=map_size/2
	bb_set_start_round_time()
	map_size = bb_get_world_size()
	bb_connect_in_game_signals()
#	$StartRound.start()
	print("map size:  "+str(map_size))


func bb_connect_in_game_signals():
	#Interface
	InGameSignals.connect("pause_snake",$Player,"bb_on_pause_snake")
	InGameSignals.connect("pause_world",$World,"bb_on_pause_world")
	InGameSignals.connect("show_choose_snake_panel",$ChooseSnake,"bb_on_show_choose_snake_panel")
	#ChooseSnake
	InGameSignals.connect("snake_was_choosen",$Player,"bb_on_snake_was_choosen")
	InGameSignals.connect("mute_snake_button_pressed",$PlayMusicFromSnake,"bb_on_mute_snake_button_pressed")
	InGameSignals.connect("snake_was_choosen_so_activate_interface",$Interface,"bb_activate_interface")
	InGameSignals.connect("delete_snake",$Player,"bb_on_delete_button_pressed")
	InGameSignals.connect("clear_snakes_world",$World,"bb_on_clear_snakes_world")
	InGameSignals.connect("show_settings",$AnimationPlayer,"bb_play_fade_all_to_show_settings")
	#Settings
	InGameSignals.connect("i_am_changing_bpm",$PlayMusicFromSnake,"bb_player_is_changing_bpm")
	InGameSignals.connect("i_am_finished_changing_bpm",$PlayMusicFromSnake,"bb_player_is_finished_changing_bpm")
	InGameSignals.connect("show_main_menu_back",$AnimationPlayer,"bb_play_fade_all_to_hide_settings")
	InGameSignals.connect("update_metre",$Player,"bb_on_update_metre")
	InGameSignals.connect("update_key",$Player,"bb_on_update_key")
	#Player
	InGameSignals.connect("tell_Interface_to_update_board",$Interface,"bb_update_score")
	InGameSignals.connect("tell_World_i_ve_gained_point",$World,"bb_apple_eated")
	#Player\Snake
	InGameSignals.connect("update_music",$PlayMusicFromSnake,"bb_update_music")
	InGameSignals.connect("stage_have_changed",$World,"bb_prepare_background")
	InGameSignals.connect("tell_ChooseSnake_i_ve_gained_point",$ChooseSnake,"bb_update_score_in_ChooseSnake")
	#PlayMusicFromSnake
	InGameSignals.connect("show_who_is_playing",$Player,"bb_show_which_element_is_playing")
	#AnimationPlayer
	InGameSignals.connect("enable_buttons_from_main_menu",$ChooseSnake,"enable_buttons_for_one_snake")


func bb_set_start_round_time():
	$StartRound.wait_time = wait_before_snake_start


func bb_get_world_size():
	var screen_size_x = ProjectSettings.get_setting("display/window/size/width")
	var screen_size_y = ProjectSettings.get_setting("display/window/size/height") 
	var screen_size = Vector2(screen_size_x,screen_size_y)
	return screen_size


func _on_StartRound_timeout():
	bb_start_snake()


func bb_start_snake():
	player.get_node("Snake1").bb_create_new_snake(start_pos,start_orientation.normalized(),map_size)




