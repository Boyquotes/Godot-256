extends Node
class_name PlatformCommand

signal finished(action_name)
signal started(action_name)

export var enabled:bool = false setget set_enabled
export onready var actor:Object 

func _ready():
	connect("started",self,"_start_function")
	connect("finished",self,"_finish_function")
	set_physics_process(false)

func set_enabled(value):
	enabled = value
	set_physics_process(value)
	set_process_unhandled_input(value)
	if enabled:
		actor.anim_tree.transitions_for_commands([self,get_parent()])
		emit_signal("started")
	elif not enabled:
		emit_signal("finished")



func check_switches(command):
	command.check_necessary_swiches()
	var turn = get_parent().get_parent().get_parent()._current_turn
	var state = get_parent().get_parent()._current_state
	if not command.necessary_swiches.empty():
		var number_of_true_keys:int = 0
		for key in command.necessary_swiches:
			if command.necessary_swiches[key] == true:
				number_of_true_keys +=1
		if number_of_true_keys == command.necessary_swiches.size():
			command.set_physics_process(true)
			command.set_process_unhandled_input(true)
			emit_signal("started",[command, state, turn])
		elif not command.is_physics_processing():
			return
		else:
			command.set_physics_process(false)
			command.set_process_unhandled_input(false)
			emit_signal("finished",command)
