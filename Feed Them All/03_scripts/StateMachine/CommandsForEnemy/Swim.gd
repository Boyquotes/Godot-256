extends "res://03_scripts/StateMachine/PlatformCommand.gd"

func _unhandled_input(event):
	pass

func _physics_process(delta):
	pass

func _start_function():

	actor.pointer_anim.play("Pointer")
	attack()

func _finish_function():
	pass

func attack():
	actor.set_linear_velocity(actor.velocity)
	actor.set_linear_damp(0)
