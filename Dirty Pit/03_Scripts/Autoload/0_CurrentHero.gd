## CURRENT HERO ###

extends Node

var matrix_of_action_dependencies = [
	[0,0,0,1,3,3,0],
	[0,0,0,3,1,3,0],
	[0,0,0,3,3,1,0],
	[1,2,2,2,2,2,2],
	[2,1,2,2,2,2,2],
	[2,2,1,2,2,2,2],
	[0,0,0,3,3,3,0],
]
# ROWS REPRESENT ACTION NR FROM OPPONENT
# COLUMNS SHOWS ACTION NR FROM HERO
# IF 0 - NO INTERACTION
# IF 1 - THERE WAS A BLOCK
# IF 2 - HERO WAS HITTED
# IF 3 - OPPONENT WAS HITTED

var interactions = []

var current_hero = "Gunter" setget set_current_hero
var current_opponent = "Gunter" setget set_current_opponent

var hero_sequance = []
var opponent_sequance = []

func set_current_hero(value):
	current_hero = value

func set_current_opponent(value):
	current_opponent = value

func price_for_rise_rank_up(rank):
	var price = 100
	match rank:
		1:
			price =50
		2:
			price =100
		3:
			price =150
		4:
			price =200
		5:
			price =300
		6:
			price =500
		7:
			price =700
		8:
			price =900
		9:
			price =1500
		_:
			price =3000
	return price


var gold_reward_rank_multiplier = 10
var gold_price_rank_multiplier = 10

var edge1 = 1
var edge2 = 2
var edge3 = 3
var edge4 = 4
var edge5 = 5
var edge6 = 6
var edge7 = 7
var edge8 = 8
var edge9 = 9



func gold_intervals(amount):
	var interval
	if amount <= edge1:
		interval=1
	elif amount > edge1 and amount <= edge2:
		interval=2
	elif amount > edge2 and amount <= edge3:
		interval=3
	elif amount > edge3 and amount <= edge4:
		interval=4
	elif amount > edge4 and amount <= edge5:
		interval=5
	elif amount > edge5 and amount <= edge6:
		interval=6
	elif amount > edge6 and amount <= edge7:
		interval=7
	elif amount > edge7 and amount <= edge8:
		interval=8
	elif amount > edge8 and amount <= edge9:
		interval=9
	elif amount > edge9:
		interval=10
	return interval
