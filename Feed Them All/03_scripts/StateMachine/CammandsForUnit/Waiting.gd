extends "res://03_scripts/StateMachine/PlatformCommand.gd"

var speed = 1
var velocity = Vector2(-1,0)
var max_easy_speed = 4
var max_medium_speed = 5
var max_hard_speed = 6


func _unhandled_input(event):
	pass

func _physics_process(delta):
	move_with_stream(delta,DifficultyScaler.difficulty_level,actor)
	if actor.timer_in_battle.time_left <= 3:
		actor.rotation_degrees += 40*delta
	pass

func _start_function():
	actor.timer_in_battle.wait_time = actor.waiting_time_befor_float_away
	actor.timer_in_battle.start()
	if actor.state_machine._previous_state.name == "TakingOutOfBoxState":
		actor.activate_collision_areas()


func _finish_function():
	actor.timer_in_battle.stop()
	stop_eyes_anim()
	pass

func move_with_stream(delta,value,somebody):
	match somebody.get_main_scene.difficulty_mode:
		0:
			somebody.position +=  velocity * delta * (speed + min(value * 0.1 , max_easy_speed))
		1:
			somebody.position +=  velocity * delta * (speed + min(value * 0.1 , max_medium_speed))
		2:
			somebody.position +=  velocity * delta * (speed + min(value * 0.1 , max_hard_speed))

func stop_eyes_anim():
	if actor.get_node("EyesAnim").is_playing():
		actor.get_node("EyesAnim").stop()
	if actor.get_node("BodyAnim").is_playing():
		actor.get_node("BodyAnim").stop()
