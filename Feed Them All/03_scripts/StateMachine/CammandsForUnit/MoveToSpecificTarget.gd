extends "res://03_scripts/StateMachine/PlatformCommand.gd"

const DISTANCE_THRESHOLD: = 1.0 
var target
var _velocity: = Vector2.ZERO
var final_rotation = 0.00001

func _unhandled_input(event):
	pass

func _physics_process(delta):
	move_function()
	pass

func _start_function():
	pass

func _finish_function():
	pass

func move_function():
	if not target == null:
		if actor.global_position.distance_to(target) < DISTANCE_THRESHOLD:
			actor.rotation = lerp(actor.rotation,final_rotation,0.1)
			if actor.rotation / final_rotation >= 0.95 and actor.rotation / final_rotation<=1.05:
				target == null
				match actor.tutorial_mode:
					true:
						actor.state_machine.change_state_to("TutorialState")
						actor.get_main_scene.get_node("TUTORIAL").emit_signal("show_next_advice",actor.get_main_scene.get_node("TUTORIAL").tutorial_step)
						actor.set_selected(false)
					false:
						actor.state_machine.change_state_to("InBattleState")
		else:
			_velocity=Movement.go(
				_velocity,
				actor.global_position,
				target
				)
			_velocity = actor.move_and_slide(_velocity)
			actor.rotation = _velocity.angle()+deg2rad(-90)

