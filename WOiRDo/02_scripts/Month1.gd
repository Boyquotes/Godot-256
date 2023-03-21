extends Control

var day_package = preload("res://01_scenes/Day.tscn")
var day_tween


var month = ""
var year_nr = 0
var month_nr = 0

var nr_of_days=0

func _ready():
	$Sign.read_sign(month)
	bb_load_days()
	pass # Replace with function body.

func bb_start_params(name,year,tween):
	month = name+" "+str(year)
	day_tween=tween


func bb_load_days():
	pass

func bb_create_day(d,m,y):
	var day1 = day_package.instance()
	nr_of_days+=1
	year_nr=y
	month_nr=m
	day1.rect_position=bb_find_pos()
	day1.name="Day"+str(d)
	day1.bb_start_params(d,m,y,day_tween)
	$Days.add_child(day1)

func bb_find_pos():
	var pos = Vector2(45+95*((nr_of_days-1)%5) ,750 - (90*ceil((40-nr_of_days)/5)))
	return pos
