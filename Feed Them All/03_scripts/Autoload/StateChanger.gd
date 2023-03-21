extends Node2D

enum {
	ANY_UNITS_NOT_SETECTED, 
	ADD_OR_REMOVE_SOME_UNITS
	SOME_UNITS_SELECTED
	SETTING_A_TARGET_TO_MOVE
}

onready var get_main_scene = get_tree().get_root().get_node("Main")

func _add_or_remove(event):
	if event is InputEventKey and event.scancode == KEY_SHIFT:
		if event.is_pressed():
			get_main_scene.set_state(ADD_OR_REMOVE_SOME_UNITS)
		if not event.is_pressed():
			if get_main_scene.selected_units.empty():
				get_main_scene.set_state(ANY_UNITS_NOT_SETECTED)
			else:
				get_main_scene.set_state(SOME_UNITS_SELECTED)


