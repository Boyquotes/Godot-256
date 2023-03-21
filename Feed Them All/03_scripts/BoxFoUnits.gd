extends Node2D

var left_border = 20
var right_border = 140
var top_border = 25
var bottom_border = 55

var centre_point

onready var get_main_scene = get_tree().get_root().get_node("Main")
onready var box = $Units

var in_box_unit_package = load("res://02_scenes/InBoxUnit.tscn")

enum BOX {
	BLUE,
	YELLOW,
	GREEN
}

export var kind_of_box = BOX.BLUE setget set_kind_of_box

func set_kind_of_box(value: int):
	match value:
		0:
			kind_of_box = BOX.BLUE
		1:
			kind_of_box = BOX.YELLOW
		2:
			kind_of_box = BOX.GREEN

func _ready():
	centre_point = Vector2((left_border+right_border)/2-10,(top_border+bottom_border)/2+20)
	pass # Replace with function body.

func clear_boxes():
	for unit in $Units.get_children():
		take_unit_out_of_box(unit)

func start_number_of_units(number):
	var number_of_units_already_in_the_box = $Units.get_child_count()
	var odds = number_of_units_already_in_the_box - number
	
	if odds <= -get_main_scene.max_number_of_units_in_the_box:
		odds = -get_main_scene.max_number_of_units_in_the_box
	if odds == 0:
		pass
	elif odds < 0:
		for i in range(abs(odds)):
			add_unit_to_box()
	elif odds > 0:
		for i in range(abs(odds)):
			take_unit_out_of_box($Units.get_child(i))

func add_unit_to_box():
	var in_box_unit = in_box_unit_package.instance()
	get_node("Units").add_child(in_box_unit)
	randomize()
	in_box_unit.original_loc_pos = Vector2(rand_range(left_border,right_border),rand_range(bottom_border,top_border))
	in_box_unit.position = in_box_unit.original_loc_pos
	match kind_of_box:
		0:
			in_box_unit.get_node("Body").modulate = Color(0,0,1,0.3)
		1:
			in_box_unit.get_node("Body").modulate = Color(1,1,0,0.3)
		2:
			in_box_unit.get_node("Body").modulate = Color(0,1,0,0.3)

func take_unit_out_of_box(unit):
	unit.queue_free()

func squize_units_befor_taking_one():
	if not $Units.get_children().empty():
		for unit in $Units.get_children():
			unit.tween_squize.interpolate_property(unit, "position",
			 unit.original_loc_pos, centre_point, 1,
			 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			unit.tween_squize.start()

func stop_squizing_units():
	if not $Units.get_children().empty():
		for unit in $Units.get_children():
			unit.tween_squize.stop(unit, "position")
			unit.tween_squize.interpolate_property(unit, "position",
			 unit.position, unit.original_loc_pos, 0.2,
			 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			unit.tween_squize.start()
