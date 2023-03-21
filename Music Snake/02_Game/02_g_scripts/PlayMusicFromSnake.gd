extends Node

#####################
# TIMERS
# 75 bpm -> wait_time = 0.2
# 80 bpm -> wait_time = 0.1875
# 100 bpm -> wait_time = 0.15
# 120 bpm -> wait_time = 0.125
# 125 bpm -> wait_time = 0.12
# 150 bpm -> wait_time = 0.1
# to get wait_time(bpm) = 1/(bpm/60*4)

# DrumSet
onready var drum_bass = get_node("../Sounds/DrumSet/drum_bass")
onready var snare_drum = get_node("../Sounds/DrumSet/snare_drum")
onready var sticks = get_node("../Sounds/DrumSet/sticks")
onready var tom_tom_1 = get_node("../Sounds/DrumSet/tom_tom_1")
onready var tom_tom_2 = get_node("../Sounds/DrumSet/tom_tom_2")

# Piano
onready var piano_c = get_node("../Sounds/Piano/PianoC")
onready var piano_d = get_node("../Sounds/Piano/PianoD")
onready var piano_e = get_node("../Sounds/Piano/PianoE")
onready var piano_f = get_node("../Sounds/Piano/PianoF")
onready var piano_g = get_node("../Sounds/Piano/PianoG")
onready var piano_a = get_node("../Sounds/Piano/PianoA")
onready var piano_b = get_node("../Sounds/Piano/PianoB")
onready var piano_c2 = get_node("../Sounds/Piano/PianoC2")

# Bass

onready var bass_c = get_node("../Sounds/Bass/BassC1")
onready var bass_d = get_node("../Sounds/Bass/BassD1")
onready var bass_e = get_node("../Sounds/Bass/BassE1")
onready var bass_f = get_node("../Sounds/Bass/BassF1")
onready var bass_g = get_node("../Sounds/Bass/BassG1")
onready var bass_a = get_node("../Sounds/Bass/BassA1")
onready var bass_b = get_node("../Sounds/Bass/BassB1")
onready var bass_c2 = get_node("../Sounds/Bass/BassC2")
var already_playing_bass = null

var muted={
	"Snake1":true,
	"Snake2":true,
	"Snake3":true
}

var notes={
	"Snake1":[],
	"Snake2":[],
	"Snake3":[]
}


var playing_snakes = []
var note_order = 1
var track_length = 1

func _ready():
	bb_on_mute_snake_button_pressed(1)
	bb_on_mute_snake_button_pressed(2)
	bb_on_mute_snake_button_pressed(3)

func bb_player_is_changing_bpm():
	$Timer.stop()

func bb_player_is_finished_changing_bpm(bpm):
	$Timer.wait_time = 1/(bpm/60*4)
	bb_restart_timer()

func bb_on_mute_snake_button_pressed(snake_nr):
	bb_set_muted_on_off_for_snake(snake_nr)
	bb_set_track_length()
	bb_restart_timer()


func bb_update_music(snake_name,notes_in_array):
#	get_node("Timer").stop()
	notes[snake_name]=notes_in_array
#	note_order = 1
	bb_set_track_length()
#	bb_restart_timer()

func bb_set_muted_on_off_for_snake(snake_nr):
	if muted[("Snake"+str(snake_nr))]==true:
		muted[("Snake"+str(snake_nr))] = false
		playing_snakes.append(("Snake"+str(snake_nr)))
	else:
		muted[("Snake"+str(snake_nr))] = true
		playing_snakes.erase(("Snake"+str(snake_nr)))

func bb_restart_timer():
	for snake_name in muted:
		if muted[snake_name]==false:
			get_node("Timer").start()
			return
	get_node("Timer").stop()

func bb_set_track_length():
	var length = 0
	for each_note_col in notes:
		if muted[each_note_col] == false:
			if notes[each_note_col].size() > length:
				length = notes[each_note_col].size()
	track_length = length


func _on_Timer_timeout():
	if track_length > 0:
		for snake in playing_snakes:
			match snake:
				"Snake1":
					if note_order <= notes[snake].size() and not notes[snake].empty():
						bb_play_Snake_1(notes[snake][note_order-1])
					else:
						bb_play_Snake_1(-1)
				"Snake2":
					if note_order <= notes[snake].size() and not notes[snake].empty():
						bb_play_Snake_2(notes[snake][note_order-1])
					else:
						bb_play_Snake_2(-1)
				"Snake3":
					if note_order <= notes[snake].size() and not notes[snake].empty():
						bb_play_Snake_3(notes[snake][note_order-1])
					else:
						bb_play_Snake_3(-1)
		note_order += 1
		if note_order>track_length:
			note_order = 1

func bb_play_Snake_1(note):
	match note:
		-1:
			pass
		0:
			InGameSignals.emit_signal("show_who_is_playing","Snake1",note_order,"empty")
		1:
			drum_bass.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake1",note_order,"full")
		2:
			snare_drum.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake1",note_order,"full")
		3:
			sticks.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake1",note_order,"full")
		4:
			tom_tom_1.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake1",note_order,"full")
		5:
			tom_tom_2.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake1",note_order,"full")


func bb_play_Snake_2(note):
	match note:
		-1:
			pass
		0:
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"empty")
		1:
			piano_c.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"full")
		2:
			piano_d.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"full")
		3:
			piano_e.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"full")
		4:
			piano_f.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"full")
		5:
			piano_g.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"full")
		6:
			piano_a.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"full")
		7:
			piano_b.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"full")
		8:
			piano_c2.play()
			InGameSignals.emit_signal("show_who_is_playing","Snake2",note_order,"full")


func bb_play_Snake_3(note):
	if already_playing_bass and not note==0:
		already_playing_bass.stop()
	match note:
		-1:
			pass
		0:
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"empty")
		1:
			bass_c.play(0)
			already_playing_bass = bass_c
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"full")
		2:
			bass_d.play(0)
			already_playing_bass = bass_d
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"full")
		3:
			bass_e.play(0)
			already_playing_bass = bass_e
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"full")
		4:
			bass_f.play(0)
			already_playing_bass = bass_f
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"full")
		5:
			bass_g.play(0)
			already_playing_bass = bass_g
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"full")
		6:
			bass_a.play(0)
			already_playing_bass = bass_a
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"full")
		7:
			bass_b.play(0)
			already_playing_bass = bass_b
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"full")
		8:
			bass_c2.play(0)
			already_playing_bass = bass_c2
			InGameSignals.emit_signal("show_who_is_playing","Snake3",note_order,"full")


