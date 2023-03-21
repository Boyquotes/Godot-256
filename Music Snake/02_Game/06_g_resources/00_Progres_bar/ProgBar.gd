extends Control

var point_symbol_package = preload("res://02_Game/06_g_resources/00_Progres_bar/NewPointSymbol.tscn")

var points = 0
var max_points = 0

func _ready():
	max_points = get_node("MarginContainer/Points").get_child_count()

func bb_add_point(value):
	if points<max_points:
		for i in value:
			points += 1
			get_node("MarginContainer/Points").get_child(points-1).bb_change_activity()

func bb_sub_point(value):
	if points>0:
		for i in value:
			get_node("MarginContainer/Points").get_child(points-1).bb_change_activity()
			points -= 1
