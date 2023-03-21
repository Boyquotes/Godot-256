extends "res://03_scripts/StateMachine/PlatformCommand.gd"

export var speed_of_floating = 200
export var speed_of_ratating = 40

func _unhandled_input(event):
	pass

func _physics_process(delta):
	actor.position.x -= speed_of_floating*delta
	actor.rotation_degrees += speed_of_ratating*delta
	if actor.position.x <= -100:
		match actor.get_main_scene.difficulty_mode:
			0:
				actor.state_machine.change_state_to("SendToBaseState2")
			1:
				actor.state_machine.change_state_to("SendToBaseState2")
			2:
				actor.show_unit_lost(50,actor.position.y)
				delete_evidence_of_existance()
				actor.state_machine.change_state_to("DieingState")

func _start_function():
	actor.set_selected(false)
	actor.cancel_setting_target()
	SettingTarget.selected_units.erase(actor)
	actor.disable_collision_areas()

func _finish_function():
	pass

func delete_evidence_of_existance():
	actor.get_main_scene._take_of_unit_from_battle(actor.kind_of_unit)
	actor.get_main_scene.check_max_number_of_unit()
	actor.get_main_scene.difficulty_checker()
