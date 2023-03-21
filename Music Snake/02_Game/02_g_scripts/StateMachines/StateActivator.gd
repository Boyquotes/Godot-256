extends Node

signal entered
signal exited

var active = false setget bb_set_active

func _ready():
	pass

func bb_set_active(activate):
	active = activate
	for command in get_children():
		command.enabled = active
		if active:
			emit_signal("entered")
		else:
			emit_signal("exited")
