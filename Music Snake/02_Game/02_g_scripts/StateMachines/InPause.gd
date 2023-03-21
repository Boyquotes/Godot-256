extends "res://02_Game/02_g_scripts/StateMachines/PlatformCommand.gd"

func _ready():
	pass

func _unhandled_input(event):
	pass

func _physics_process(delta):
	pass

func _start_function():
	actor.visible=false
	bb_move_out_or_in_of_the_screen(actor,-1.0)

func _finish_function():
	actor.visible=true
	if global_values.already_in_game:
		bb_move_out_or_in_of_the_screen(actor,1.0)

#OTHER FUNCTIONS

func bb_move_out_or_in_of_the_screen(somebody,dir):
	var distance
	match somebody.get_parent().name[-1]:
		"1":
			distance = 10000
		"2":
			distance = 15000
		"3":
			distance = 20000
	somebody.position.x += dir*distance

