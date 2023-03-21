extends Node2D

enum {
	YOU_ARE_ON_HUD,
	ANY_UNITS_NOT_SETECTED, 
	ADD_OR_REMOVE_SOME_UNITS,
	SOME_UNITS_SELECTED,
	SETTING_A_TARGET_TO_MOVE
}

var draging = false
var drag_start = Vector2.ZERO
var select_rect = RectangleShape2D.new()
var selected_units = []

onready var get_main_scene = get_tree().get_root().get_node("Main")

func _rect_selection(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				if selected_units.size() == 0:
					draging = true
					drag_start = event.position
				else:
					for item in selected_units:
						item.set_selected(false)
					selected_units = []
					get_main_scene.set_state(ANY_UNITS_NOT_SETECTED)
			elif draging:
				draging = false
				update()
				var drag_end = event.position
				select_rect.extents = (drag_end-drag_start) /2
				var space = get_world_2d().direct_space_state
				var query = Physics2DShapeQueryParameters.new()
				query.set_shape(select_rect)
				query.transform = Transform2D(0,(drag_end+drag_start)/2)
				var query_results = []
				query_results = space.intersect_shape(query)
				for result in query_results:
					if result.collider is KinematicBody2D:
						var state_name = result.collider.state_machine._current_state.name
						if not selected_units.has(result.collider) and (state_name=="InBattleState" or state_name=="MovingAwayState" or state_name=="TutorialState"):
							selected_units.append(result.collider)
				for item in selected_units:
					item.set_selected(true)
				if not selected_units.empty():
					if not selected_units[0].tutorial_mode:
						get_main_scene.set_state(SOME_UNITS_SELECTED)
	if event is InputEventMouseMotion and draging:
		update()
	return selected_units


func _add_or_remove(event):
	if event is InputEventKey and event.scancode == KEY_SHIFT:
		if event.is_pressed():
			get_main_scene.set_state(ADD_OR_REMOVE_SOME_UNITS)
		if not event.is_pressed():
			if get_main_scene.selected_units.empty():
				get_main_scene.set_state(ANY_UNITS_NOT_SETECTED)
			else:
				get_main_scene.set_state(SOME_UNITS_SELECTED)

func _remove_all(event):
	if not get_main_scene.selected_units.empty():
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				for item in selected_units:
					item.set_selected(false)
				selected_units = []
				get_main_scene.set_state(ANY_UNITS_NOT_SETECTED)
	else:
		get_main_scene.set_state(ANY_UNITS_NOT_SETECTED)
	return selected_units


func _draw():
	if draging:
		draw_rect(Rect2(drag_start,get_global_mouse_position()-drag_start),
		Color(1,0.0,0.0,0.2))
