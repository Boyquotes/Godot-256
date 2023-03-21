extends AnimationPlayer

var is_playing_backwords = false

export (NodePath) var settings_node_path = ".."

var window_on_screen = WINDOW_ON_SCREEN.MAIN setget bb_set_window_on_screen

func bb_set_window_on_screen(value):
	match value:
		0:
			window_on_screen = WINDOW_ON_SCREEN.TRANSIT_POINT
		1:
			window_on_screen = WINDOW_ON_SCREEN.MAIN
		2:
			window_on_screen = WINDOW_ON_SCREEN.SETTINGS

enum WINDOW_ON_SCREEN {
	TRANSIT_POINT
	MAIN
	SETTINGS
}

func bb_play_fade_all_to_show_settings():
	play("FadeAll")
	is_playing_backwords = false


func bb_play_fade_all_to_hide_settings():
	play("FadeAll")
	is_playing_backwords = false



func _on_AnimationPlayer_animation_finished(anim_name):
	match is_playing_backwords:
		true:
			match window_on_screen:
				0:
					pass
				1:
					InGameSignals.emit_signal("enable_buttons_from_main_menu")
					pass

				2:
					pass

		false:
			match window_on_screen:
				0:
					pass
				1:
					get_node(settings_node_path).visible = true
					bb_set_window_on_screen(2)
					is_playing_backwords = true
					play_backwards("FadeAll")

				2:
					get_node(settings_node_path).visible = false
					bb_set_window_on_screen(1)
					is_playing_backwords = true
					play_backwards("FadeAll")

