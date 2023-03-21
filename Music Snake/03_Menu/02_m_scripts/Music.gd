extends Node2D

onready var menu_music = $Menu/MenuMusic


export var music_on = true 
var already_playing = 1

var track_position = {
	1:0.0
}

func _ready():
	pass
#	play_music()

func set_music_on():
	match music_on:
		false:
			music_on = true
			match already_playing:
				1:
					menu_music.play(track_position[1])
		true:
			music_on = false
			match already_playing:
				1:
					track_position[1] = menu_music.get_playback_position()
					menu_music.stop()

func play_music(music_nr = 1):
	if music_on:
		match music_nr:
			1:
				already_playing = 1
				menu_music.play()

func _on_MenuMusic_finished():
	if music_on:
		menu_music.play()
