extends "res://02_Game/02_g_scripts/StateMachines/PlatformCommand.gd"

var screen_size = Vector2(0,0)

var field_size_left = -600
var field_size_right = 3000
var field_size_top = -600
var field_size_bottom = 4900

var local_head_orien = Vector2(0,0)
var sprite_size = 256

func _ready():
	pass

func _unhandled_input(event):
	pass

func _physics_process(delta):
	pass


func _start_function():

	var new_loc = bb_find_new_location(
		actor.transform.xform(actor.get_node("Orientation/Top").position), 
		actor.transform.xform(actor.get_node("Orientation/Down").position))
	local_head_orien = (actor.position-new_loc).normalized()
#	actor.position = Vector2(new_loc.x-1*local_head_orien.x*sprite_size,new_loc.y-1*local_head_orien.x*sprite_size)
	actor.position = Vector2(new_loc.x,new_loc.y)
#	print("new point is: " +str(actor.position))
	bb_add_path_point_to_transfer(actor)
#	global_values.point_to_draw_2 = actor.position
	global_values.update()
	actor.state_machine.bb_change_state_to("GoingIntoFieldState")


func _finish_function():
	pass

#OTHER FUNCTIONS


func bb_find_new_location(vec1,vec2):
	
	var new_position
	var direction = 0
	var inside_head_orientation = (vec1-vec2).normalized()
#	var inside_head_orientation = head_orientation
	var new_vec1 = Vector2(vec1.x, vec1.y * -1)
	var new_vec2 = Vector2(vec2.x, vec2.y * -1)


	var denominator = new_vec1.x - new_vec2.x 

	var a_constant = null
	var b_constant = null
	if not denominator == 0:
		a_constant = (new_vec1.y-new_vec2.y)/denominator
		b_constant = new_vec2.y - new_vec2.x * a_constant
		if a_constant > 0:
			direction = 1
		elif a_constant < 0:
			direction = -1
#	print("b constant is:  " + str(b_constant))
#	print("a constant is:  " + str(a_constant))
	match direction:
		0:
			
			if denominator == 0:
				# pattern is: x = new_vec1.x
				if inside_head_orientation.y > 0:
					new_position = Vector2(new_vec1.x,field_size_top)
				else:
					new_position = Vector2(new_vec1.x,field_size_bottom)
			else:
				# pattern is: y = b_constant
				if inside_head_orientation.x > 0:
					new_position = Vector2(field_size_left,-new_vec1.y)
				else:
					new_position = Vector2(field_size_right,-new_vec1.y)
		1:
#			print("its 1")
			# pattern is: y = a_constant * x + b_constant
			# a_constant > 0
			if inside_head_orientation.x > 0:
#				print("its 1 going right")

				# b2 y point of crossing line with field_size_left
				var b2 = a_constant * field_size_left + b_constant

				if -b2 <= field_size_bottom:
					new_position = Vector2(field_size_left, -(a_constant * field_size_left + b_constant))
				else:
					new_position = Vector2((-field_size_bottom-b_constant)/a_constant, field_size_bottom)
			else:
				if (-field_size_top-b_constant)/a_constant >= field_size_right:
					new_position = Vector2(field_size_right,-(a_constant * field_size_right + b_constant))
				else:
					new_position = Vector2((-field_size_top-b_constant)/a_constant,field_size_top)

		-1:
#			print("its -1")
			# pattern is: y = a_constant * x + b_constant
			# a_constant < 0

			if inside_head_orientation.x > 0:
#				print("its -1 going right")

				# b2 y point of crossing line with field_size_left
				var b2 = a_constant * field_size_left + b_constant
				if b2 >= -field_size_top:
					new_position = Vector2((-field_size_top-b_constant)/a_constant,field_size_top)
				else:
					new_position = Vector2(field_size_left,-(a_constant * field_size_left + b_constant))
			else:
#				print("its -1 going left")
				if -(a_constant*field_size_right + b_constant) >= field_size_bottom:
					new_position = Vector2((-field_size_bottom-b_constant)/a_constant,field_size_bottom)
				else:
					new_position = Vector2(field_size_right,-(a_constant * field_size_right + b_constant))
					
#	print("points to calculate line formula create vector : " +str((vec1-vec2).normalized()))
#	print("a const is:  " + str(a_constant))
#	print("b const is:  " + str(b_constant))

	return new_position


func bb_add_path_point_to_transfer(somebody):
	if somebody.name=="Head" and somebody.get_parent().nr_of_elements >0:
		global_values.pivot_points["Torso_1"].append(somebody.transform)


#
#func bb_find_new_location(vec1,vec2):
#	var new_position
#	var direction = 0
#	var inside_head_orientation = (vec1-vec2).normalized()
##	var inside_head_orientation = head_orientation
#	var new_vec1 = Vector2(vec1.x, vec1.y * -1)
#	var new_vec2 = Vector2(vec2.x, vec2.y * -1)
#
#
#	var denominator = new_vec1.x - new_vec2.x 
#	var a_constant = null
#	var b_constant = null
#	if not denominator == 0:
#		a_constant = (new_vec1.y-new_vec2.y)/denominator
#		b_constant = new_vec2.y - new_vec2.x * a_constant
#		if a_constant > 0:
#			direction = 1
#		elif a_constant < 0:
#			direction = -1
##	print("b constant is:  " + str(b_constant))
##	print("a constant is:  " + str(a_constant))
#	match direction:
#		0:
#
#			if denominator == 0:
#
#				# pattern is: x = new_vec1.x
#				if inside_head_orientation.y > 0:
#					new_position = Vector2(new_vec1.x,0)
#				else:
#					new_position = Vector2(new_vec1.x,screen_size.y)
#			else:
#				# pattern is: y = b_constant
#				if inside_head_orientation.x > 0:
#					new_position = Vector2(0,-new_vec1.y)
#				else:
#					new_position = Vector2(screen_size.x,-new_vec1.y)
#		1:
#
#			# pattern is: y = a_constant * x + b_constant
#			# a_constant > 0
#			if inside_head_orientation.x > 0:
##				print("its 1 going right")
#				if -b_constant <= screen_size.y:
#					new_position = Vector2(0, -b_constant)
#				else:
#					new_position = Vector2((-screen_size.y-b_constant)/a_constant, screen_size.y)
#			else:
##				print("its 1 going left")
#				if -b_constant/a_constant >= screen_size.x:
#					new_position = Vector2(screen_size.x,-(a_constant * screen_size.x + b_constant))
#				else:
#					new_position = Vector2(-b_constant/a_constant,0)
#
#		-1:
#			# pattern is: y = a_constant * x + b_constant
#			# a_constant < 0
#			if inside_head_orientation.x > 0:
##				print("its -1 going right")
#				if b_constant >= 0:
#					new_position = Vector2(-b_constant/a_constant,0)
#				else:
#					new_position = Vector2(0,-b_constant)
#			else:
##				print("its -1 going left")
#				if -(a_constant*screen_size.x + b_constant) >= screen_size.y:
#					new_position = Vector2((-screen_size.y-b_constant)/a_constant,screen_size.y)
#				else:
#					new_position = Vector2(screen_size.x,-(a_constant * screen_size.x + b_constant))
#
##	print("points to calculate line formula create vector : " +str((vec1-vec2).normalized()))
##	print("a const is:  " + str(a_constant))
##	print("b const is:  " + str(b_constant))
##	print("new point is  :" + str(new_position))
#
#	return new_position
