extends Node


signal state_changed()

export (NodePath) var actor_path = ".."
onready var actor = get_node(actor_path)


onready var _current_state = get_child(0)
onready var _previous_state = _current_state

func _ready():
	for state in get_children():
		for command in state.get_children():
			command.actor = actor
	yield(get_tree(),"idle_frame")
	change_state_to(get_child(0).name)

func change_state_to(new_state_name):
	var new_state = get_node(new_state_name)
	_previous_state = _current_state
	_current_state = new_state
	initialize_current_state()
	emit_signal("state_changed", new_state_name)

func initialize_current_state():
	_previous_state.active = false
	_current_state.active = true


