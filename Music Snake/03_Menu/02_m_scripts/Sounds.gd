extends Node2D

onready var click = $Menu/Click

export var sound_on = true 

func _ready():
	pass # Replace with function body.

func set_sound_on():
	match sound_on:
		false:
			sound_on = true
		true:
			sound_on = false

func play_sound(sound_nr = 1):
	if sound_on:
		match sound_nr:
			1:
				click.play()
