extends "res://03_scripts/StateMachine/PlatformCommand.gd"

var target 
var vocuum_pos = Vector2(-800,400)

const DISTANCE_THRESHOLD: = 1.0 
var _velocity: = Vector2.ZERO


func _unhandled_input(event):
	pass

func _physics_process(delta):
	if actor.global_position.distance_to(target) < DISTANCE_THRESHOLD:
		actor.queue_free()
	else:
		_velocity=Movement.go(
			_velocity,
			actor.global_position,
			target
			)
		_velocity = actor.move_and_slide(_velocity)
		actor.rotation = _velocity.angle()+deg2rad(-90)

func _start_function():
	actor.set_selected(false)
	actor.cancel_setting_target()
	SettingTarget.selected_units.erase(actor)
	target = vocuum_pos
	disable_collision_areas()


func _finish_function():
	pass

func disable_collision_areas():
	var mouth = actor.get_node("Mouth")
	var body = actor.get_node("Body")
	mouth.set_deferred("monitoring", false)
	mouth.set_deferred("monitorable", false)
	body.set_deferred("monitoring", false)
	body.set_deferred("monitorable", false)

