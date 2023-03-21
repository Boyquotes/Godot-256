extends Node2D

var already_in_game = false

var food_name = ""

onready var core = get_node("../../..")

var apple_package = preload("res://02_Game/01_g_scenes/Apple.tscn")

var on_screen = {
	"Drum_kit":{
		"Apple_0":false,
		"Apple_1":false,
		"Apple_2":false,
		"Apple_3":false,
		"Apple_4":false,
		"Apple_5":false
	},
	"Piano":{
		"Apple_0":false,
		"Apple_1":false,
		"Apple_2":false,
		"Apple_3":false,
		"Apple_4":false,
		"Apple_5":false,
		"Apple_6":false,
		"Apple_7":false,
		"Apple_8":false,
	},
	"Bass":{
		"Apple_0":false,
		"Apple_1":false,
		"Apple_2":false,
		"Apple_3":false,
		"Apple_4":false,
		"Apple_5":false,
		"Apple_6":false,
		"Apple_7":false,
		"Apple_8":false,
	}
}

func _ready():
	bb_asign_food_number()
	pass # Replace with function body.

func bb_asign_food_number():
	match name[-1]:
		"1":
			food_name="Drum_kit"
		"2":
			food_name="Piano"
		"3":
			food_name="Bass"

func _on_FoodSpawner_timeout():
#	print("blablacar" + str(on_screen))
	for key in on_screen[food_name]:
		if on_screen[food_name][key] == false:
			var pos = bb_take_rand_pos()
			if not pos==null:
				var new_apple = apple_package.instance()
				new_apple.position = pos
				new_apple.start_func(food_name)
				new_apple.set_type_of_apple(int(key[-1]))
				add_child(new_apple)
				on_screen[food_name][key] = true
			else:
				print("hogward")


func bb_check_if_new_place_is_valid(somebody,point):
	var select_poly = RectangleShape2D.new()
	var select_poly_transform = Transform2D(Vector2(1,0),Vector2(0,1),point)
	select_poly.extents = Vector2(90,90)
	var space = somebody.get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_layer = 14
	query.set_shape(select_poly)
	query.transform = select_poly_transform
#	query.exclude = [somebody.body_collision_shape.get_parent()]
	var query_results = []
	query_results = space.intersect_shape(query)
	var overlapping_objects = []
	for i in query_results:
		overlapping_objects.append(i["collider"])
	return overlapping_objects


func bb_take_rand_pos():
	var coord
	var count = 0
	coord = Vector2(rand_range(100,core.map_size.x-100),rand_range(100,core.map_size.y-100))
	while not bb_check_if_new_place_is_valid(self,coord).empty():
		coord = Vector2(rand_range(100,core.map_size.x-100),rand_range(100,core.map_size.y-100))
		count += 1
		if count == 1000:
			coord = null
			break
	return coord

func bb_clear_food(food_nr):
	for i in get_children():
		if not i.name=="FoodSpawner":
			i.queue_free()
	for item in on_screen[food_name].keys():
		on_screen[food_name][item]=false
