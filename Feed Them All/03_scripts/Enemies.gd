extends Node2D

signal no_enemies

var number_of_active_enemies = 0

func check_number_of_active_enemies():
	number_of_active_enemies = get_children().size()

func set_number_of_active_enemies(value):
	match value:
		-1:
			number_of_active_enemies -= 1
		+1:
			number_of_active_enemies += value
	if number_of_active_enemies == 0:
		emit_signal("no_enemies")


