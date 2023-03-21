extends "res://03_scripts/StateMachine/PlatformCommand.gd"

func _unhandled_input(event):
	pass

func _physics_process(delta):
	pass

func _start_function():
	_is_eated()
	pass

func _finish_function():
	pass

func _is_eated():
	yield(get_tree().create_timer(0.2),"timeout")
	actor.queue_free()


