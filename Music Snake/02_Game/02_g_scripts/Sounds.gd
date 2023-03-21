extends Node2D


func _ready():
#	change_volume()
	pass # Replace with function body.


func change_volume():
	for bass_note in $Bass.get_children():
		bass_note.volume_db = 0
	for piano_note in $Piano.get_children():
		piano_note.bus = "Master"
