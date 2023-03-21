extends Node2D

export (NodePath) var speed_bar_from_settings_path
export (NodePath) var metre_path



export var sprite_size = 256
export var sprite_scale = 0.25
export var max_turn_sum = 180
export var interface_pos_in_pause = Vector2(-5000,-5000)

# variants for controlling snake
var head_orientation = Vector2(0,1)
var head_rotation = 0
var screen_size = Vector2(0,0)

#Variants showing score
var points = 0
var nr_of_elements = 0

var snake_on_screen = 0
var all_snakes_in_array = []


func _ready():
	set_process(false)
	bb_fill_array_of_snakes()

func bb_fill_array_of_snakes():
	for snake in get_children():
		if not snake.name=="Tween":
			all_snakes_in_array.append(snake)

func bb_on_snake_was_choosen(snake_nr:int):
	snake_on_screen = snake_nr
	var snake = get_node(("Snake"+str(snake_nr)))
	match snake.already_in_game: 
		true:
			bb_move_snake_back_into_screen(snake)
			
		false:
			bb_create_new_snake(snake,get_parent().start_pos,get_parent().start_orientation,get_parent().map_size)
	get_node("../World").bb_prepare_background(snake.stage)
	snake.get_node("Head/HeadCamera").current= true
	InGameSignals.emit_signal("tell_Interface_to_update_board",nr_of_elements)
#	snake.get_node("SnakeInterface/PauseGame").disabled = false
	bb_update_snakes_data(snake)


func bb_update_snakes_data(snake:Object):
	var updated_speed = get_node(speed_bar_from_settings_path).value *100
	snake.get_node("Head/StateMachine/InFieldState/InField").speed = updated_speed
	snake.get_node("Head/StateMachine/GoingIntoFieldState/GoingIntoField").speed = updated_speed


func bb_create_new_snake(snake:Object,head_pos = Vector2(1,1), head_orien = Vector2(0,1),sc_size = Vector2.ZERO):
	snake.head_orientation = head_orien
	snake.head_rotation = rad2deg(head_orientation.angle()) - 90
	snake.screen_size = sc_size
	snake.get_node("Head").rotation_degrees = head_rotation
	snake.get_node("Head").position = head_pos
	snake.get_node("Head").state_machine.bb_start_machine()
	bb_activate_world(str(snake.name[-1]))
	InGameSignals.emit_signal("tell_Interface_to_update_board",0)
	snake.already_in_game = true

func bb_create_transit_points(sc_field:Array):
	for snake in all_snakes_in_array:
		snake.get_node("Head/StateMachine/TransitState/Transit").field_size_left = sc_field[0]
		snake.get_node("Head/StateMachine/TransitState/Transit").field_size_top = sc_field[1]
		snake.get_node("Head/StateMachine/TransitState/Transit").field_size_bottom = sc_field[2]
		snake.get_node("Head/StateMachine/TransitState/Transit").field_size_right = sc_field[3]

func bb_activate_world(nr_of_world):

	get_node("../World").food_on_screen = int(nr_of_world)

	get_node("../World/Foods/Food"+str(nr_of_world)+"/FoodSpawner").start()
	get_node("../World/Foods/Food"+str(nr_of_world)).already_in_game = true



func bb_on_pause_snake():
	var snake = get_node(("Snake"+str(snake_on_screen)))
	for element in snake.get_children():
		if not element.name == "SnakeInterface":
			element.state_machine.call_deferred("bb_change_state_to","InPauseState")


func bb_move_snake_back_into_screen(snake:Object):
	InGameSignals.emit_signal("tell_Interface_to_update_board",snake.nr_of_elements)
	get_node("../World").food_on_screen = int(snake.name[-1])
	get_node("../World").bb_on_unpause_world()
	for element in snake.get_children():
		if not element.name == "SnakeInterface":
			element.state_machine.bb_change_state_to(element.state_machine._previous_state)


func bb_show_which_element_is_playing(snake_name,element_nr,type):
	var short = snake_name + "/"+"Torso_" + str(element_nr)
	var element = get_node(short)
	if int(snake_name[-1]) == snake_on_screen:

		match type:
			"full":
				$Tween.interpolate_property(element,"scale",Vector2(1.5,1.5),Vector2(1,1),0.5,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
			"empty":
				$Tween.interpolate_property(element,"scale",Vector2(0.8,0.8),Vector2(1,1),0.5,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()


func bb_update_score(snake_number,number):
	var short = "Snake" +snake_number+ "/SnakeInterface/Score"
	if typeof(number)==TYPE_INT:
		get_node(short).text = str(number)
	else:
		push_error("Wrong variant type!")


func bb_restart_world_for_specific_food(nr):
	get_node("../World/Foods/Food"+str(nr)).bb_clear_food(nr)
	get_node("../World/Foods/Food"+str(nr)).visible = true
	get_node("../World/Foods/Food"+str(nr)).position = Vector2(0,0)


func bb_on_delete_button_pressed(nr):
	var short = "Snake" + str(nr)
	match get_node(short).nr_of_elements:
		0:
			pass
		_:
			get_node(short).bb_destroy_hitted_torso(get_node(short).get_node("Torso_1"))
			get_node(short).get_node("Head").state_machine.bb_change_state_to("InFreezeState")
			get_node(short).stage = 1
			get_node(short).already_in_game = false
			bb_restart_world_for_specific_food(nr)

func bb_on_update_metre(bot,top):
	print("need to update metre:  "+str(bot)+str(top))
	for snake in all_snakes_in_array:
		for torso in snake.get_children():
			if not torso.name=="Head":
				torso.bb_give_tint_to_show_place_in_song(bot,top)


func bb_on_update_key(key):
	print("need to update key:  " + str(key))
	pass
