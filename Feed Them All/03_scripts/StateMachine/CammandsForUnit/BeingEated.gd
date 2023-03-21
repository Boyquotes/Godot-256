extends "res://03_scripts/StateMachine/PlatformCommand.gd"

func _unhandled_input(event):
	pass

func _physics_process(delta):
	pass

func _start_function():
	actor.cancel_setting_target()
	actor.get_main_scene._take_of_unit_from_battle(actor.kind_of_unit)

func _finish_function():
	pass


