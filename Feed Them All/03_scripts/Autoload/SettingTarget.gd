extends Node2D

enum {
	YOU_ARE_ON_HUD,
	ANY_UNITS_NOT_SETECTED,
	ADD_OR_REMOVE_SOME_UNITS, 
	SOME_UNITS_SELECTED,
	SETTING_A_TARGET_TO_MOVE
}


onready var get_main_scene = get_tree().get_root().get_node("Main")
onready var target_mark_package = load ("res://02_scenes/TargetMark.tscn")


onready var selected_units = get_main_scene.selected_units
var line_start = Vector2.ZERO
var draging = false
var start_target = false


### variables for _input(event) ###
var arrow = null
var target = [] ##all instances in an array
var list_of_ranges = [] ##shows lengths of line which change number of rows 
var dict_of_rows = {} ##containing conditions setting number of rows in reference to line's length
var stored_final_target_positions = {}


### variables for _process(delta) ###
var border_points = [0]
var number_of_rows = 0
var target_in_rows = [[]]
var number_of_rows_changed = false
var final_rotation = 0


### exported variables  ###
export var distance_in_row = 30
export var distance_in_column = 60


func _target(event):
	if event.is_action_pressed("mouse_left"):
		get_main_scene.set_state(SETTING_A_TARGET_TO_MOVE)
		stored_final_target_positions.clear()
		selected_units = get_main_scene.selected_units
		draging = true
		start_target = false
		border_points = [0]
		line_start = event.position
		for i in range(selected_units.size()):
			var sprite = target_mark_package.instance()
			add_child(sprite)
			target.append(sprite)
	if event.is_action_released("mouse_left"):
		if (get_global_mouse_position()-line_start).length() > 0.1:
			for item in selected_units:
				start_target = true
				item.state_machine.change_state_to("MovingState")
				pass
		elif (get_global_mouse_position()-line_start).length() <= 0.1:
			pass
		for item in selected_units:
			item.set_selected(false)
		draging = false
		for item in target:
			item.anim.play("fade_out")
		target = []
		RectSelection.selected_units = []
		#arrow.queue_free()
		update()
		get_main_scene.set_state(ANY_UNITS_NOT_SETECTED)
	if draging and event is InputEventMouseMotion:
		update()


func _draw():
	if not get_main_scene.selected_units.empty():
		if draging:
			draw_line(line_start,get_global_mouse_position(),get_main_scene.selected_units[0].get_node("Unit").get_modulate(),10)

func _target_process(delta):
	if not get_main_scene.selected_units.empty():
		if draging:
			number_of_rows=0
	
			var selected_units_in_rows = [[]]
			var line_length: int = (get_global_mouse_position()-line_start).length()
	
			#arrow.position = get_global_mouse_position()
			#arrow.rotation = (get_global_mouse_position()-line_start).angle()-deg2rad(90)
			var normal_vector = (get_global_mouse_position()-line_start).normalized()
			for i in range(selected_units.size()):
				if border_points.size()>=(selected_units.size()):
					break
				else:
					border_points.append(10*i+100)
	
			for i in range(0,border_points.size()):
				if list_of_ranges.size()>=(border_points.size()):
					break
				else:
					list_of_ranges.append("range_nr_%s" %i)
	
	
			for i in range(list_of_ranges.size()):
				if i+1 == list_of_ranges.size():
					list_of_ranges[-1] = border_points[-1]<=line_length
				else:
					list_of_ranges[i] = border_points[i]<=line_length and line_length<border_points[i+1]
	
	
			var value_befor_loop = number_of_rows
			for i in range(list_of_ranges.size()):
				dict_of_rows[list_of_ranges[i]] = i+1
			number_of_rows = dict_of_rows.get(true)
			var value_after_loop = number_of_rows
	
			if value_befor_loop != value_after_loop:
				number_of_rows_changed = true
			else:
				number_of_rows_changed = false
	
	
			if number_of_rows_changed:
				target_in_rows = [[]]
				selected_units_in_rows = [[]]
				for i in range(number_of_rows):
					if target_in_rows.size()>=number_of_rows:
						break
					target_in_rows.append([])
					selected_units_in_rows.append([])
	
				for i in range (target.size()):
					if i>=target.size():
						break
					target_in_rows[i % number_of_rows].append(target[i])
					selected_units_in_rows[i % number_of_rows].append(selected_units[i])
	
	
			for i in range(target_in_rows.size()):
				for w in range(target_in_rows[i].size()):
					if w != 0:
						if  w % 2 == 0:
							target_in_rows[i][w].position = Vector2(target_in_rows[i][0].position.x-normal_vector.y*w*distance_in_row,target_in_rows[i][0].position.y+normal_vector.x*w*distance_in_row)
						else:
							target_in_rows[i][w].position = Vector2(target_in_rows[i][0].position.x+normal_vector.y*(w+1)*distance_in_row,target_in_rows[i][0].position.y-normal_vector.x*(w+1)*distance_in_row)
					else:
						target_in_rows[i][w].position = Vector2(line_start.x-normal_vector.x*i*distance_in_column,line_start.y-normal_vector.y*i*distance_in_column)
	
	
			if number_of_rows_changed:
				for i in range(selected_units_in_rows.size()):
					for w in range(target_in_rows[i% number_of_rows].size()):
						#selected_units_in_rows[i][w].target_position = target_in_rows[i% number_of_rows][w].position
						stored_final_target_positions[selected_units_in_rows[i][w]] = target_in_rows[i% number_of_rows][w].position

	if not target.empty():
		if draging:
			var only_first = false
			for item in target:
				item.rotation = (get_global_mouse_position()-line_start).angle()-deg2rad(90)
				if not only_first:
					item.position = get_global_mouse_position()
					only_first = true
		final_rotation = target[0].rotation





	#if not selected_units.empty():
	#if start_target:
	#	for item in selected_units:
	#		item.set_target_specified(true)
	#elif not start_target:
	#	for item in selected_units:
	#		item.set_target_specified(false)


	if not draging:
		number_of_rows=0
		border_points = [0]
		list_of_ranges = []
		target_in_rows = [[]]

func create_pointer_for_tutorial():
	for i in range(selected_units.size()):
		var sprite = target_mark_package.instance()
		add_child(sprite)
		target.append(sprite)
		target.position = get_global_mouse_position()

func release_all_pointers():
		for item in target:
			item.anim.play("fade_out")

func _target_for_totorial(event):
	update()
	
