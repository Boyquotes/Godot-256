extends Node2D

const SCALING_STEP:int = 1

var bottom_border:int = 1
var top_border:int = 2
var difficulty_level:int = 1 setget set_difficulty_level,get_difficulty_level

enum DIFFICULTY_LEVEL {
		LEVEL_0,
		LEVEL_1,
		LEVEL_2,
		LEVEL_3,
		LEVEL_4,
		LEVEL_5,
		LEVEL_6,
		LEVEL_7,
		LEVEL_8,
		LEVEL_9,
		LEVEL_10,
}

func set_difficulty_level(value):
	difficulty_level += value
	match value:
		-1:
			bottom_border -= SCALING_STEP
			top_border -= SCALING_STEP
		1:
			bottom_border += SCALING_STEP
			top_border += SCALING_STEP


func get_difficulty_level():
	return difficulty_level 


func check_level(value):
	if (value-bottom_border) < 0:
		if difficulty_level > 0:
			set_difficulty_level(-1)
	if (value-top_border) >= 0:
		set_difficulty_level(1)



