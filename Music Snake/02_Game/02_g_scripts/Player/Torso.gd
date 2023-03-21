extends Sprite

var empty_sprite = preload("res://02_Game/03_g_assets/Drum_kit/empty.png")
var drum_bass_sprite = preload("res://02_Game/03_g_assets/Drum_kit/drum_bass.png")
var snare_drum_sprite = preload("res://02_Game/03_g_assets/Drum_kit/snare_drum.png")
var sticks_sprite = preload("res://02_Game/03_g_assets/Drum_kit/sticks.png")
var tom_tom_1_sprite = preload("res://02_Game/03_g_assets/Drum_kit/tom_tom_1.png")
var tom_tom_2_sprite = preload("res://02_Game/03_g_assets/Drum_kit/tom_tom_2.png")

var c_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/C.png")
var d_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/D.png")
var e_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/E.png")
var f_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/F.png")
var g_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/G.png")
var a_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/A.png")
var b_sprite = preload("res://02_Game/06_g_resources/01_Alfabeth/Fonts/Alfabeth/B.png")


var core
onready var state_machine = $StateMachine
var order_nr = 0

var object_to_follow
var object_that_follows = null

var need_to_transit = false
var transition_points = []



func _ready():
	core = get_node("../..")

	object_to_follow = get_parent().bb_take_object_to_follow(self,order_nr)
	transform = bb_get_new_position_in_accordance_to_sb(object_to_follow)

	get_parent().bb_create_pivot_points_container(self,order_nr)

	state_machine.global_values_path = state_machine.get_node("../..").get_path()
	state_machine.bb_start_machine()
	bb_give_tint_to_show_place_in_song(core.get_node(core.metre_path).metre_bot,core.get_node(core.metre_path).metre_top)


func bb_get_new_position_in_accordance_to_sb(node_ahead:Object):
	var new_trans = Transform2D(Vector2(0,0),Vector2(0,0),Vector2(0,0))
	var nodes_ahead_trans = object_to_follow.get("transform")
	var offset = get_parent().sprite_size
	new_trans.origin = Vector2(nodes_ahead_trans.origin.x-offset*nodes_ahead_trans.y.x,nodes_ahead_trans.origin.y-offset*nodes_ahead_trans.y.y)
	new_trans.x = nodes_ahead_trans.x
	new_trans.y = nodes_ahead_trans.y
	return new_trans


func bb_initialization(main_type,sub_type):
	match main_type:
		"1":
			match sub_type:
				0:
					$Sprite.texture=empty_sprite
				1:
					$Sprite.texture=drum_bass_sprite
				2:
					$Sprite.texture=snare_drum_sprite
				3:
					$Sprite.texture=sticks_sprite
				4:
					$Sprite.texture=tom_tom_1_sprite
				5:
					$Sprite.texture=tom_tom_2_sprite
		"2":
			match sub_type:
				0:
					$Sprite.texture=empty_sprite
				1:
					$Sprite.texture=c_sprite
				2:
					$Sprite.texture=d_sprite
				3:
					$Sprite.texture=e_sprite
				4:
					$Sprite.texture=f_sprite
				5:
					$Sprite.texture=g_sprite
				6:
					$Sprite.texture=a_sprite
				7:
					$Sprite.texture=b_sprite
				8:
					$Sprite.texture=c_sprite
					modulate = Color(1,0,0,1)
		"3":
			match sub_type:
				0:
					$Sprite.texture=empty_sprite
				1:
					$Sprite.texture=c_sprite
				2:
					$Sprite.texture=d_sprite
				3:
					$Sprite.texture=e_sprite
				4:
					$Sprite.texture=f_sprite
				5:
					$Sprite.texture=g_sprite
				6:
					$Sprite.texture=a_sprite
				7:
					$Sprite.texture=b_sprite
				8:
					$Sprite.texture=c_sprite
					modulate = Color(1,0,0,1)




func bb_give_tint_to_show_place_in_song(timing_bot,timing_top):
	# main tint for even bars : Color(1,0,0,1)
	# main tint for odd bars : Color(0,1,0,1)
	var number_of_sixteens = 16/timing_bot*timing_top
	match int(floor((order_nr-1)/number_of_sixteens))%2:
		0:
			$BodyTop.modulate = Color(1,0,0,1)
		1:
			$BodyTop.modulate = Color(0,1,0,1)
	
	var order_nr_but_in_first_bar = order_nr-floor((order_nr-1)/number_of_sixteens)*number_of_sixteens
	var number_tact = floor((order_nr_but_in_first_bar-1)/(16/timing_bot))

	match int(number_tact)%2:
		0:
			$BodyBot.modulate = Color(0,1,1,1)
		1:
			$BodyBot.modulate = Color(1,1,0,1)



