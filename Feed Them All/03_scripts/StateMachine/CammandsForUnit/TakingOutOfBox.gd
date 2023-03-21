extends "res://03_scripts/StateMachine/PlatformCommand.gd"


func _unhandled_input(event):
	pass

func _physics_process(delta):
	pass

func _start_function():
	pass

func _finish_function():
	pass



func change_to_in_battle_state():
	match actor.tutorial_mode:
		false:
			actor.z_index = -2
			actor.state_machine.change_state_to("InBattleState")
		true:
			actor.z_index = -2
			actor.state_machine.change_state_to("TutorialState")

func change_to_floating_away_state():
	match actor.tutorial_mode:
		false:
			actor.z_index = -2
			actor.state_machine.change_state_to("FloatingAwayState")
		true:
			actor.z_index = -2
			actor.state_machine.change_state_to("TutorialState")


func make_fully_visible():
	actor.get_node("Unit").set_light_mask(0)
	actor.get_node("Eyes").set_light_mask(0)
	actor.get_node("Mug").modulate = Color(0.63,0.4,0.4,1)
	match actor.kind_of_unit:
		0:
			actor.get_node("Unit").modulate = Color(0.0,0.0,1.0,1)
		1:
			actor.get_node("Unit").modulate = Color(1.0,1.0,0.0,1)
		2:
			actor.get_node("Unit").modulate = Color(0.0,1.0,0.0,1)



#func set_color_of_mug_for_animation():
#	var anim:Animation = actor.get_node("AnimPlayer").get_animation("Waiting")
#	match actor.kind_of_unit:
#		0:
#			var color =  Color(0.0,0.0,1.0,1)
#			var faded_color =  Color(0.0,0.0,1.0,0.5)
#			anim.track_set_key_value(1,0,color)
#			anim.track_set_key_value(1,1,faded_color)
#			anim.track_set_key_value(1,2,color)
#			anim.track_set_key_value(1,3,faded_color)
#			anim.track_set_key_value(1,4,color)
#			anim.track_set_key_value(1,5,faded_color)
#			anim.track_set_key_value(1,6,color)
#			anim.track_set_key_value(1,7,faded_color)
#			anim.track_set_key_value(1,8,color)
#		1:
#			var color =  Color(1.0,1.0,0.0,1)
#			var faded_color = Color(1.0,1.0,0.0,0.5)
#			anim.track_set_key_value(1,0,color)
#			anim.track_set_key_value(1,1,faded_color)
#			anim.track_set_key_value(1,2,color)
#			anim.track_set_key_value(1,3,faded_color)
#			anim.track_set_key_value(1,4,color)
#			anim.track_set_key_value(1,5,faded_color)
#			anim.track_set_key_value(1,6,color)
#			anim.track_set_key_value(1,7,faded_color)
#			anim.track_set_key_value(1,8,color)
#		2:
#			var color =  Color(0.0,1.0,0.0,1)
#			var faded_color =  Color(0.0,1.0,0.0,0.5)
#			anim.track_set_key_value(1,0,color)
#			anim.track_set_key_value(1,1,faded_color)
#			anim.track_set_key_value(1,2,color)
#			anim.track_set_key_value(1,3,faded_color)
#			anim.track_set_key_value(1,4,color)
#			anim.track_set_key_value(1,5,faded_color)
#			anim.track_set_key_value(1,6,color)
#			anim.track_set_key_value(1,7,faded_color)
#			anim.track_set_key_value(1,8,color)
