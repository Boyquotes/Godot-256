## THOG STATS ###

extends Node

# MAIN STATS #
var rank:int = 1
var won_fights:int = 0
var gained_experiance = 0
var gold:int = 30
var life_points:int = 2
var stamina_points:int = 3
var armor:int = 0
var attack_force:int = 0

# OTHER VARIABLES #
var top_border_of_next_rank = 3
var available = false

func create_new_top_border_of_next_rank():
	match rank:
		1:
			top_border_of_next_rank = 3
		2:
			top_border_of_next_rank = 4
		3:
			top_border_of_next_rank = 5
		4:
			top_border_of_next_rank = 6
		_:
			top_border_of_next_rank = 7


func update_stats():
	match rank:
		1:
			life_points = 2
			stamina_points = 3
		2:
			life_points = 3
			stamina_points = 5
		3:
			life_points = 4
			stamina_points = 7
		4:
			life_points = 5
			stamina_points = 9
		5:
			life_points = 5
			stamina_points = 11
		_:
			life_points = 6
			stamina_points = 13
