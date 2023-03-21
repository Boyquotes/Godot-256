extends Node2D

export var border_multiplier = 1000.0

var food_on_screen = 0


func bb_on_pause_world():
	get_node(("Foods/Food"+str(food_on_screen))).visible = false
	get_node(("Foods/Food"+str(food_on_screen))).position.x += 5000


func bb_on_unpause_world():
	get_node(("Foods/Food"+str(food_on_screen))).position.x -= 5000
	get_node(("Foods/Food"+str(food_on_screen))).visible = true


func bb_prepare_background(stage):
	bb_set_borders_location(stage)
	get_node("../Player").bb_create_transit_points(bb_get_field_size())
	bb_create_tilemap(bb_get_field_size())


func bb_set_borders_location(stage:int):
	var map_size = get_parent().map_size
	
	get_node("Border1/Shape1").position = Vector2(-200-border_multiplier*(float(stage)-1),map_size.y/2-400)
	get_node("Border1/Shape5").position = Vector2(-200-border_multiplier*(float(stage)-1),map_size.y/2-400)
	
	get_node("Border1/Shape2").position = Vector2(map_size.x/2-400,-200-border_multiplier*(float(stage)-1))
	get_node("Border1/Shape6").position = Vector2(map_size.x/2-400,-200-border_multiplier*(float(stage)-1))
	
	get_node("Border1/Shape3").position = Vector2(map_size.x/2+400,map_size.y+200+border_multiplier*(float(stage)-1))
	get_node("Border1/Shape7").position = Vector2(map_size.x/2+400,map_size.y+200+border_multiplier*(float(stage)-1))
	
	get_node("Border1/Shape4").position = Vector2(map_size.x+200+border_multiplier*(float(stage)-1),map_size.y/2+400)
	get_node("Border1/Shape8").position = Vector2(map_size.x+200+border_multiplier*(float(stage)-1),map_size.y/2+400)


func bb_get_field_size():
	var top = $Border1/Shape2.position.y
	var bot = $Border1/Shape3.position.y
	var left = $Border1/Shape1.position.x
	var right = $Border1/Shape4.position.x
	var array = [left,top,bot,right]
	return array


func bb_create_tilemap(field_size:Array):
	$Background.clear()
	var first_point = $Background.world_to_map(Vector2(field_size[0],field_size[1]))
	var second_point = $Background.world_to_map(Vector2(field_size[3],field_size[2]))
	var first_x = first_point.x
	var first_y = first_point.y
	var last_x = second_point.x
	var last_y = second_point.y
	var start_x = first_x
	var start_y = first_y
	for i in range(abs(first_x)+abs(last_x)+1):
		for x in range(abs(first_y)+abs(last_y)+1):
			$Background.set_cell(start_x,start_y,0)
			start_y += 1
		start_x += 1
		start_y = first_y
	$Background.update_bitmask_region()


func bb_apple_eated(type):
	var short = "Apple_" + str(type)
	var short_2
	match food_on_screen:
		1:
			short_2 = "Drum_kit"
		2:
			short_2 = "Piano"
		3:
			short_2 = "Bass"
	get_node("Foods/Food"+str(food_on_screen)).on_screen[short_2][short] = false
	get_node("Foods/Food"+str(food_on_screen)+"/FoodSpawner").start()


func bb_on_clear_snakes_world(nr):
	pass


