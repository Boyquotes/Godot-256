extends "res://03_scripts/StateMachine/PlatformCommand.gd"

#
# SENT UNIT TO BASE IN CASE OF TOUCHING
# RECALL BUTTON
#


var target 
var vocuum_pos = Vector2(88,512)
var pipe_start_pos = Vector2(0,505)
var in_pipe_first_pos = Vector2(0,5)
var in_pipe_second_pos
var in_pipe_third_pos 
const DISTANCE_THRESHOLD: = 1.0 
var _velocity: = Vector2.ZERO


func _unhandled_input(event):
	pass

func _physics_process(delta):
	if actor.global_position.distance_to(target) < DISTANCE_THRESHOLD:
		if target == in_pipe_third_pos:
			actor.back_to_base()
#		elif target == in_pipe_second_pos:
#			target = in_pipe_third_pos
#		elif target == in_pipe_first_pos:
#			target = in_pipe_third_pos
		elif target == pipe_start_pos:
			actor.visible = true
			target = in_pipe_third_pos
		elif target == vocuum_pos:
			actor.visible = false
			target = pipe_start_pos
			pass
		#scale = actor.scale.linear_interpolate(IN_PIPE_SCALE,0.1)
	else:
		_velocity=Movement.go(
			_velocity,
			actor.global_position,
			target
			)
		_velocity = actor.move_and_slide(_velocity)
		actor.rotation = _velocity.angle()+deg2rad(-90)

func _start_function():
	match_pipe_start_pos(actor.kind_of_unit)
	#match_in_pipe_second_pos(actor.kind_of_unit)
	match_in_pipe_third_pos(actor.kind_of_unit)
	actor.set_selected(false)
	actor.cancel_setting_target()
	SettingTarget.selected_units.erase(actor)
	target = vocuum_pos
	actor.disable_collision_areas()



func _finish_function():
	pass


func match_in_pipe_third_pos(kind):
	match kind:
		0:
			in_pipe_third_pos = Vector2(80,55)
		1:
			in_pipe_third_pos = Vector2(245,55)
		2:
			in_pipe_third_pos = Vector2(415,60)

func match_in_pipe_second_pos(kind):
	match kind:
		0:
			in_pipe_second_pos = Vector2(80,300)
		1:
			in_pipe_second_pos = Vector2(245,300)
		2:
			in_pipe_second_pos = Vector2(415,300)

func match_pipe_start_pos(kind):
	match kind:
		0:
			pipe_start_pos = Vector2(11,496)
		1:
			pipe_start_pos = Vector2(33,493)
		2:
			pipe_start_pos = Vector2(62,495)
