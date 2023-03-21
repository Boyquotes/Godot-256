extends "res://02_Game/02_g_scripts/StateMachines/PlatformCommand.gd"

var follow_speed = 100
var additional_speed = 0

func _ready():
	pass

func _unhandled_input(event):
	pass

func _physics_process(delta):
	bb_move_along_path(actor,(follow_speed+additional_speed)*delta)
	global_values.bb_create_pivot_point(actor,global_values)
	pass

func _start_function():
	follow_speed = global_values.speed
	pass

func _finish_function():
	pass

#OTHER FUNCTIONS

func bb_move_along_path(somebody:Object,speed):
	var name = somebody.name
	var next_point
	var starting_point = somebody.transform
	var walk_path = bb_take_walk_path(somebody)
	if not walk_path.empty():
		for i in walk_path.size():
			next_point = walk_path[0]

			if somebody.need_to_transit and next_point==somebody.object_to_follow.transition_points[0]:
#				print("DILDO BAGGINS")
				somebody.object_to_follow.transition_points.remove(0)
				if somebody.object_to_follow.transition_points.empty():
#					print("HARRY PORTERET")
					somebody.need_to_transit=false
#				print("ABRAHAM TO DZIWKA"+str(walk_path))

				if not somebody.object_that_follows == null:
#					if not walk_path[0] in global_values.pivot_points[global_values.bb_take_element(somebody.order_nr+1).name]:
					global_values.pivot_points[global_values.bb_take_element(somebody.order_nr+1).name].append(walk_path[0])
					var aditional_point = walk_path[0]
					aditional_point.origin.x += aditional_point.y.x
					aditional_point.origin.y += aditional_point.y.y
					somebody.transition_points.append(aditional_point)
					somebody.object_that_follows.need_to_transit=true
					global_values.pivot_points[global_values.bb_take_element(somebody.order_nr+1).name].append(aditional_point)
					global_values.pivot_points[global_values.bb_take_element(somebody.order_nr+1).name].append(walk_path[1])

				walk_path.remove(0)
#				print("now i am in point:  " + str(somebody.position))
#				print("POTOMEK MOJŻESZA TO"+str(walk_path))
				actor.transform = walk_path[0]
				break

			else:
#				print("mordor"+str(next_point.origin)+"mordor")
				var distance_to_next = starting_point.origin.distance_to(walk_path[0].origin)
	#			var distance_to_next_angle = abs(somebody.transform.y.angle()-walk_path[0].y.angle())

				if speed <= distance_to_next and speed >= 0.0:
					somebody.transform = starting_point.interpolate_with(walk_path[0],speed/distance_to_next)
					break
				elif walk_path.size() == 1 && speed > distance_to_next:
					somebody.transform = walk_path[0]
#					print("element stopped")
					break
				speed -= distance_to_next

			starting_point = walk_path[0]
	#		if get_parent().name=="Snake2" and name=="Torso1":
	#			print(starting_point.origin)
			walk_path.remove(0)



func bb_take_walk_path(somebody):
	var path
	var short = "Torso_" + str(somebody.order_nr)
	path = global_values.pivot_points[short]
	return path 


func bb_transit_through_screen(somebody:Object,walk_path):
#	print("DILDO BAGGINS")
	somebody.object_to_follow.transition_points.remove(0)
	if somebody.object_to_follow.transition_points.empty():
#		print("HARRY PORTERET")
		somebody.need_to_transit=false
#	print("ABRAHAM TO DZIWKA"+str(walk_path))
#	print("TRANSIT POINT IS:  " + str(walk_path[0].origin))
	if not somebody.object_that_follows == null:
		somebody.transition_points.append(walk_path[0])
		somebody.object_that_follows.need_to_transit=true
		if not walk_path[0] in global_values.pivot_points[global_values.bb_take_element(somebody.order_nr+1).name]:
			global_values.pivot_points[global_values.bb_take_element(somebody.order_nr+1).name].append(walk_path[0])

	walk_path.remove(0)
	if not somebody.object_that_follows == null:
		if not walk_path[0] in global_values.pivot_points[global_values.bb_take_element(somebody.order_nr+1).name]:
			global_values.pivot_points[global_values.bb_take_element(somebody.order_nr+1).name].append(walk_path[0])
#	print("POTOMEK MOJŻESZA TO"+str(walk_path))
	actor.transform = walk_path[0]
