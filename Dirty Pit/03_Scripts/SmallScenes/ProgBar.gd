extends TextureRect

var point_symbol_package = load("res://02_Scenes/Symbols/PointSymbol.tscn")

var destiny_of_progbar = DESTINY.LIFE setget set_destiny_of_progbar
export var number_of_spaces = 2 setget set_number_of_spaces
export var filed_spaces = 2 setget set_filed_spaces
var total_width = rect_size.x-50
var space_width = 50


enum DESTINY{
	RANK,
	LIFE,
	STAMINA
}



func set_destiny_of_progbar(value):
	destiny_of_progbar = value

func set_number_of_spaces(value:int):
	number_of_spaces = value
	space_width = total_width/value
	if value <= 0:
		return
	if value == $Points.get_child_count():
		for i in range($Points.get_child_count()):
			$Points.get_child(i).initial_setup(destiny_of_progbar,space_width)
	if value < $Points.get_child_count():
		var differ = $Points.get_child_count() - value
		for i in range(differ):
			$Points.get_child($Points.get_child_count()-i-1).queue_free()
		for i in range($Points.get_child_count()):
			$Points.get_child(i).initial_setup(destiny_of_progbar,space_width)
	else:
		for i in range($Points.get_child_count()):
			$Points.get_child(i).initial_setup(destiny_of_progbar,space_width)
		for i in range(value-$Points.get_child_count()):
			var point_symbol = point_symbol_package.instance()
			point_symbol.initial_setup(destiny_of_progbar,space_width)
			$Points.add_child(point_symbol)

func set_filed_spaces(value:int):
	filed_spaces = value
	if value <= 0:
		if $Points.get_child_count() != 0:
			for i in range($Points.get_child_count()):
				$Points.get_child(i).queue_free()
			return
	if value >= number_of_spaces:
		return
	if value < $Points.get_child_count():
		var differ = $Points.get_child_count() - value
		for i in range(differ):
			$Points.get_child($Points.get_child_count()-i-1).queue_free()
	else:
		for i in range(value-$Points.get_child_count()):
			var point_symbol = point_symbol_package.instance()
			point_symbol.initial_setup(destiny_of_progbar,space_width)
			$Points.add_child(point_symbol)

func lost_point(how_much):
	if how_much > 2:
		return
	if $Points.get_child_count() <= 0:
		return
	if $Points.get_child_count() < how_much:
		return
	match how_much:
		1:
			$Points.get_child($Points.get_child_count()-1).lost_point()
		2:
			$Points.get_child($Points.get_child_count()-1).lost_point()
			$Points.get_child($Points.get_child_count()-2).lost_point()

func _ready():
	pass # Replace with function body.

func start_setup(destiny):
	match destiny:
		0:
			set_destiny_of_progbar("RANK")
		1:
			set_destiny_of_progbar("LIFE")
		2:
			set_destiny_of_progbar("STAMINA")






func _on_Button1_pressed():
	set_number_of_spaces(3)


func _on_Button2_pressed():
	set_number_of_spaces(5)

func _on_Button3_pressed():
	lost_point(2)
