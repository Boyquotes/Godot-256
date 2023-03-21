extends Node

signal state_changed()

export (NodePath) var actor_path = ".."
export (NodePath) var global_values_path = ".."

onready var actor = get_node(actor_path)
onready var global_values = get_node(global_values_path)

onready var _current_state = get_child(0)
onready var _previous_state = _current_state

func _ready():
	pass

func bb_start_machine():
	for state in get_children():
		for command in state.get_children():
			command.actor = actor
			command.global_values = global_values
	yield(get_tree(),"idle_frame")
	bb_change_state_to(get_child(0).name)

func bb_change_state_to(new_state_name):
	var new_state
	if new_state_name is Object:
		new_state = new_state_name
	else:
		new_state = get_node(new_state_name)
	_previous_state = _current_state
	_current_state = new_state
	bb_initialize_current_state()
	emit_signal("state_changed", new_state_name)

func bb_initialize_current_state():
	_previous_state.active = false
	_current_state.active = true


