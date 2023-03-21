extends Control


func _ready():
	pass # Replace with function body.


func bb_print_achivements():
	var day_a
	var day_nr=Content.achivements[1]
	if day_nr==0:
		day_a=0
	else:
		day_a=round(Content.achivements[0]/day_nr)
	
	var week_a
	var week_nr=Content.achivements[3]
	if week_nr==0:
		week_a=0
	else:
		week_a=round(Content.achivements[2]/week_nr)
	
	var month_a
	var month_nr=Content.achivements[5]
	if month_nr==0:
		month_a=0
	else:
		month_a=round(Content.achivements[4]/month_nr)
	
	var full_a
	var full_nr=Content.achivements[7]
	if full_nr==0:
		full_a=0
	else:
		full_a=round(Content.achivements[6]/full_nr)


	$Day/Average2.read_sign(str(day_a)+"%")
	$Day/Amount2.read_sign(str(day_nr))
	$Week/Average2.read_sign(str(week_a)+"%")
	$Week/Amount2.read_sign(str(week_nr))
	$Month/Average2.read_sign(str(month_a)+"%")
	$Month/Amount2.read_sign(str(month_nr))
	$Full/Average2.read_sign(str(full_a)+"%")
	$Full/Amount2.read_sign(str(full_nr))
