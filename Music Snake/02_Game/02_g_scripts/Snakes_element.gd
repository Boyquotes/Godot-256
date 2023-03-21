extends Sprite

onready var core = get_node("../..")
onready var state_machine

var break_point = null
var going_though_wall = false
var list_of_transfer_points = []

var my_order_number = 0

func _ready():
	bb_asign_begin_order_number()
	set_process(false)
#	print("Core name is :  " + str(core.name))
	pass

func bb_asign_begin_order_number():
	match name:
		"Head":
			my_order_number = 0
		"Tail":
			my_order_number = 1


func _process(delta):
#	if get_parent().name=="Snake2":
#		if name=="Head":
#			print("I am working")

	if not my_order_number == core.nr_of_elements and not going_though_wall:
		bb_create_pivot_points()

	match self.name:
		"Head":
			position += core.head_orientation.normalized() * core.speed * delta
		_:
			if not going_though_wall:
				bb_move_along_path(self,core.speed * delta)


func bb_move_along_path(somebody:Object,speed):
	var name = somebody.name
	var next_point
	var starting_point = somebody.transform
	var walk_path = bb_take_walk_path()
	for i in walk_path.size():
		next_point = walk_path[0]

		if break_point:
			if next_point==break_point:
				core.bb_tell_elemets_they_can_move()
				break_point=null
		if not list_of_transfer_points.empty():
			if next_point == list_of_transfer_points[0]:
				somebody.transform = walk_path[1]
				somebody.going_though_wall = true
				yield(get_tree(), "idle_frame")
				yield(get_tree(), "idle_frame")



				starting_point = somebody.transform
				walk_path.remove(0)
				walk_path.remove(1)
				next_point = walk_path[0]
				list_of_transfer_points.remove(0)
				somebody.going_though_wall = false

		
		var distance_to_next = starting_point.origin.distance_to(walk_path[0].origin)
		if speed <= distance_to_next and speed >= 0.0:
			somebody.transform = starting_point.interpolate_with(walk_path[0],speed/distance_to_next)
			break
		elif walk_path.size() == 1 && speed > distance_to_next:
			somebody.transform = walk_path[0]
			print("element stopped")
			break
		speed -= distance_to_next
		starting_point = walk_path[0]
#		if get_parent().name=="Snake2" and name=="Torso1":
#			print(starting_point.origin)
		walk_path.remove(0)



func bb_take_walk_path():
	var path
	var short = "Element_" + str(my_order_number)
	path = core.pivot_points[short]
	return path 

func bb_create_pivot_points():
	var short = "Element_" + str(my_order_number+1)
	core.pivot_points[short].append(get_transform())

func bb_create_and_save_path():
	var path
