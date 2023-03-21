extends Sprite

onready var core = get_node("../..")
onready var state_machine = $StateMachine

var my_order_number = 0
var object_that_follows = null
var transition_points = []



func _ready():
	pass



func bb_create_pivot_points():
	var short = "Element_" + str(my_order_number+1)
	core.pivot_points[short].append(get_transform())


func bb_snake_eated_apple(type):
	get_parent().type_of_elements_in_order.append(type) # to make music
#	var last_element = get_parent().bb_take_element(get_parent().nr_of_elements)
#	get_parent().bb_add_element_to_snake(last_element.transform,get_parent().sprite_size,get_parent().name[-1],type)
	get_parent().bb_add_element_to_snake(get_parent().name[-1],type)
	InGameSignals.emit_signal("tell_World_i_ve_gained_point",type)


	call_deferred("bb_emit_music_signal")


func bb_emit_music_signal():
	InGameSignals.emit_signal("update_music",get_parent().name,get_parent().type_of_elements_in_order)


func bb_make_transit_point():
	if not object_that_follows==null:
		if not transform in get_parent().pivot_points["Torso_1"]:
			get_parent().pivot_points["Torso_1"].append(transform)
		var aditional_point = transform
		aditional_point.origin.x += aditional_point.y.x
		aditional_point.origin.y += aditional_point.y.y
		transition_points.append(aditional_point)
		object_that_follows.need_to_transit = true
		get_parent().pivot_points["Torso_1"].append(aditional_point)
#		print("transit:  " + str(transform.origin))


func _on_HeadColl_area_entered(area):
#	print("entered  " + str(get_node("StateMachine/InFieldState/InField").local_head_orien))
#	get_parent().point_to_draw_1 = position
	match area.name:
		"AppleArea":
			bb_snake_eated_apple(area.get_parent().type_of_apple)
		"TorsoArea":
#			print("I HIT MYSELF!")
			get_parent().bb_destroy_hitted_torso(area.get_parent())
		_:
			if state_machine._current_state.name=="InFieldState":
				bb_make_transit_point()
				state_machine.bb_change_state_to("TransitState")
			if state_machine._current_state.name=="TransitState":
				state_machine.bb_change_state_to("GoingIntoFieldState")

func _on_HeadColl_area_exited(area):
#	print("exited  ")
	if state_machine._current_state.name=="GoingIntoFieldState":
		state_machine.bb_change_state_to("InFieldState")


