extends "res://03_scripts/StateMachine/PlatformCommand.gd"

const DISTANCE_THRESHOLD: = 1.0 
var target_position
var occupied_rotation 
var _velocity: = Vector2.ZERO


func _unhandled_input(event):
	pass


func _physics_process(delta):
	move_function()
	pass


func _start_function():
	occupied_rotation = SettingTarget.final_rotation
	take_target()


func _finish_function():
	pass


func move_function():
	if occupied_rotation == 0:
		occupied_rotation +=0.00001
	if actor.global_position.distance_to(target_position) < DISTANCE_THRESHOLD:
		actor.rotation = lerp(actor.rotation,occupied_rotation,0.1)
		if actor.rotation / occupied_rotation >= 0.9 and actor.rotation / occupied_rotation<=1.10:
			SettingTarget.start_target = false
			actor.state_machine.change_state_to("InBattleState")
	else:
		_velocity=Movement.go(
			_velocity,
			actor.global_position,
			target_position
			)
		_velocity = actor.move_and_slide(_velocity)
		actor.rotation = _velocity.angle()+deg2rad(-90)


func take_target():
	target_position = SettingTarget.stored_final_target_positions[actor]

