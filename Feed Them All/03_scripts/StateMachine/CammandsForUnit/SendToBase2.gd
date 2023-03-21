extends "res://03_scripts/StateMachine/PlatformCommand.gd"

#
# SENT UNIT TO BASE IN CASE OF TOUCHING
# SIDES OF SCREEN, MY OR ENEMY BASE
#

var target 

var in_pipe_first_pos 
var in_pipe_second_pos 
const DISTANCE_THRESHOLD: = 5.0 
var _velocity: = Vector2.ZERO


func _unhandled_input(event):
	pass

func _physics_process(delta):
	if not target == null:
		if actor.global_position.distance_to(target) < DISTANCE_THRESHOLD:
			if target == in_pipe_second_pos:
				actor.back_to_base()
			elif target == in_pipe_first_pos:
				target = in_pipe_second_pos
		else:
			_velocity=Movement.go(
				_velocity,
				actor.global_position,
				target
				)
			_velocity = actor.move_and_slide(_velocity)
			actor.rotation = _velocity.angle()+deg2rad(-90)

func _start_function():
	actor.disable_collision_areas()
	match_in_pipe_first_pos(actor.kind_of_unit)
	match_in_pipe_second_pos(actor.kind_of_unit)
	actor.cancel_setting_target()
	target = in_pipe_first_pos



func _finish_function():
	pass

func match_in_pipe_second_pos(kind):
	match kind:
		0:
			in_pipe_second_pos = Vector2(80,80)
		1:
			in_pipe_second_pos = Vector2(240,80)
		2:
			in_pipe_second_pos = Vector2(400,80)

func match_in_pipe_first_pos(kind):
	match kind:
		0:
			in_pipe_first_pos = Vector2(80,100)
		1:
			in_pipe_first_pos = Vector2(240,100)
		2:
			in_pipe_first_pos = Vector2(400,100)

