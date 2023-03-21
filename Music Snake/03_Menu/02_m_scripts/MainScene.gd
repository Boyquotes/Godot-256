extends Node2D

func _ready():
	connect_signals()
	$BootAnim.start_boot_anim()

func connect_signals():
	#BootAnim
	GlobalSignals.connect("boot_ended",self,"on_boot_ended")
	#Menu
	GlobalSignals.connect("start_game_clicked",self,"on_start_game_clicked")
	GlobalSignals.connect("make_click_sound",$Sounds,"play_sound")
	GlobalSignals.connect("music_clicked",$Music,"set_music_on")
	GlobalSignals.connect("sounds_clicked",$Sounds,"set_sound_on")

func on_boot_ended():
	$Menu.enable_buttons()

func on_start_game_clicked():
	$Menu.visible = false
	$Game/Snake_2.bb_start_snake()
