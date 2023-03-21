extends Node2D

export var speed := 500
export var head_orien_speed_change := 150
export var sprite_size = 256
export var max_pivot_points_for_one_element = 40

var torso_package = load("res://02_Game/01_g_scenes/Torso_1.tscn")

var head_orientation = Vector2(0,1)
var head_rotation = 0
var screen_size = Vector2(0,0)
var pivot_points = {
}


var nr_of_elements = 0
var stage = 1
var type_of_elements_in_order = []
var already_in_game = false


var points_required_to_increase_stage={
	"2":5,
	"3":10,
	"4":15
}


var stages_gained={
	"2":false,
	"3":false,
	"4":false
}


func _ready():
	bb_start_function()
	pass # Replace with function body.


func bb_start_function():
	match name[-1]:
		"1":
			$Head.modulate = Color(1,1,1,1)
		"2":
			$Head.modulate = Color(1,0,1,1)
		"3":
			$Head.modulate = Color(1,0,0,1)


func bb_add_element_to_snake(main_type,sub_type):
	nr_of_elements += 1
	var new_Torso = torso_package.instance()
	new_Torso.name = "Torso_" + str(nr_of_elements)
	new_Torso.order_nr = nr_of_elements
	new_Torso.bb_initialization(main_type,sub_type)
	call_deferred("add_child",new_Torso)
	InGameSignals.emit_signal("tell_Interface_to_update_board",nr_of_elements)
	InGameSignals.emit_signal("tell_ChooseSnake_i_ve_gained_point",nr_of_elements)
	bb_stage_checker(nr_of_elements)


func bb_stage_checker(number):
	if not stage == int(stages_gained.keys()[-1]):
		var next_stage = stage +1
		var border = points_required_to_increase_stage[str(next_stage)]
		if number == border and not stages_gained[str(next_stage)]:
			stage += 1
			InGameSignals.emit_signal("stage_have_changed",stage)


func bb_take_out_nrs_from_type_of_elements_in_order(nr):
	type_of_elements_in_order.resize(nr)
	InGameSignals.emit_signal("update_music",name,type_of_elements_in_order)


func bb_destroy_hitted_torso(torso):
	torso.object_to_follow.object_that_follows = null
	torso.object_to_follow.transition_points.clear()
	torso.state_machine.bb_change_state_to("DestroyState")
	torso.name = "hitted_torso"
	var number = torso.order_nr
	nr_of_elements = number-1
	bb_take_out_nrs_from_type_of_elements_in_order(nr_of_elements)
	var list_of_torsos_to_destroy = []
	var object = torso.object_that_follows
	while object:
		list_of_torsos_to_destroy.append(object)
		object = object.object_that_follows
	for element in list_of_torsos_to_destroy:
		element.state_machine.bb_change_state_to("DestroyState")
	for element in list_of_torsos_to_destroy:
		element.queue_free()
	torso.queue_free()
	InGameSignals.emit_signal("tell_Interface_to_update_board",nr_of_elements)
	InGameSignals.emit_signal("tell_ChooseSnake_i_ve_gained_point",nr_of_elements)

func bb_accelerate_all_torsos(value):
	for torso in get_children():
		if not torso.name == "Head":
			torso.get_node("StateMachine/WaitState/WaitState").additional_speed = value


func bb_take_element(nr):
	var element_name
	if nr==0:
		element_name = "Head"
	else:
		element_name = "Torso_" + str(nr)
	var element
	if not get_node(element_name):
		element = get_child(get_child_count()-1)
	else:
		element = get_node(element_name)
	return element


func bb_create_pivot_points_container(object_that_needs_points,order_nr):
	var nr = object_that_needs_points.name
	var object:Object = object_that_needs_points.object_to_follow
	var point = object.transform
	pivot_points[nr] = [object_that_needs_points.transform,point]


func bb_take_object_to_follow(object_that_follows,order_nr):
	var object_to_follow:Object
	match order_nr:
		1:
			object_to_follow = get_node("Head")
			get_node("Head").object_that_follows = object_that_follows
		_:
			var nr = "Torso_" + str(order_nr-1)
			object_to_follow = get_node(nr)
			object_to_follow.object_that_follows = object_that_follows
	return object_to_follow


func bb_create_pivot_point(somebody:Object,source_of_data):
	if not somebody.object_that_follows == null:
		var name_of_object_that_follows = somebody.object_that_follows.name
		if source_of_data.pivot_points[name_of_object_that_follows].size()<=3:
				if somebody.position.distance_to(somebody.object_that_follows.position)>=source_of_data.sprite_size:
					source_of_data.pivot_points[name_of_object_that_follows].append(somebody.transform)


