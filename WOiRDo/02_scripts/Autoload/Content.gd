extends Node

var content={}

var achivements = [0,0,0,0,0,0,0,0]
#var achivements = [day_suma,0,0,0,0,0,0,0]
#var content_pattern={
#	2014:{9:{30:[[]]}
#	}
#}

var nr_of_woirdos=0

func bb_does_this_month_exist(y,m):
	if content[y].has(m):
		return true
	else:
		return false

func bb_create_day(y,m,d):
	if not content.has(y):
		content[y]={}
	if not content[y].has(m):
		content[y][m]={}
	if not content[y][m].has(d):
		content[y][m][d]=[]


func bb_save_new_content(y,m,d,c):
	if content.has(y):
		if content[y].has(m):
			if content[y][m].has(d):
				content[y][m][d].append(c)
			else:
				content[y][m][d] = []
				content[y][m][d].append(c)
		else:
			content[y][m]={}
			content[y][m][d] = []
			content[y][m][d].append(c)
	else:
		content[y]={}
		content[y][m]={}
		content[y][m][d] = []
		content[y][m][d].append(c)

func bb_correct_content(y,m,d,nr,c):
	content[y][m][d][nr] = c

func bb_delete_content(y,m,d,nr):
	content[y][m][d].remove(nr)
	if content[y][m][d].empty():
		content[y][m].erase(d)
	if content[y][m].empty():
		content[y].erase(m)
	if content[y].empty():
		content.erase(y)

func bb_delete_day(y,m,d):
	if content.has(y):
		if content[y].has(m):
			if content[y][m].has(d):
				content[y][m].erase(d)


func bb_delete_month(y,m):
	if content.has(y):
		if content[y].has(m):
			content[y].erase(m)
		if content[y].empty():
			content.erase(y)



func bb_give_me_nr_of_months():
	var nr = 0
	if content.empty():
		pass
	else:
		for year in content:
			for mon in content[year]:
				nr += 1
	return nr

func bb_give_me_order_nr_of_month(y,m):
	var nr=0
	for year in content[y]:
		for month in content[y].keys():
			nr+=1
			if month==m:
				return nr

func bb_give_me_order_nr_of_day(y,m,d):
	var nr=0
	for year in content[y]:
		for month in content[y][m]:
			for day in content[y][m].keys():
				nr+=1
				if day==d:
					return nr

func bb_give_me_nr_of_days_in_month(y,m):
	var nr = 0
	if content.empty():
		pass
	else:
		for days in content[y][m]:
				nr += 1
	return nr

func bb_give_me_nr_of_duos_in_day_in_month(y,m,d):
	var nr = 0
	if content.empty():
		pass
	else:
		for dou in content[y][m][d]:
				nr += 1
	return nr

func bb_give_me_nr_words_in_day(y,m,d):
	var nr=0
	var words=[]
	if content.has(y):
		if content[y].has(m):
			if content[y][m].has(d):
				nr = content[y][m][d].size()
				for duo in range(nr):
					words.append(content[y][m][d][duo])
	return [nr,words]

func bb_give_me_words_in_last_week(y,m,d):
	var nr=0
	var words=[]
	if content.has(y):
		if content[y].has(m):
			for i in range(7):
				if content[y][m].has(d-i):
					for duo in content[y][m][d-i].size():
						nr+=1
						words.append(content[y][m][d-i][duo])
		if d<=6 and content[y].has(m-1):
			for i in range(7-d):
				var temp_variable=bb_days_in_real_month(m)
				if content[y][m-1].has(temp_variable-i):
					for duo in content[y][m-1][temp_variable-i].size():
						nr+=1
						words.append(content[y][m-1][temp_variable-i][duo])
	if m==1 and d<=6 and content.has(y-1):
		if content[y-1].has(12):
			for i in range(7-d):
				if content[y-1][12].has(31-i):
					for duo in content[y-1][12][31-i].size():
						nr+=1
						words.append(content[y-1][12][31-i][duo])
	return [nr,words]

func bb_give_me_words_in_last_month(y,m,d):
	var nr=0
	var words=[]
	if content.has(y):
		if content[y].has(m):
			if (m==1 or m==3 or m==5 or m==7 or m==8 or m==10 or m==12):
				for i in range(31):
					if content[y][m].has(d-i):
						for duo in content[y][m][d-i].size():
							nr+=1
							words.append(content[y][m][d-i][duo])
			elif (m==4 or m==6 or m==9 or m==11):
				for i in range(30):
					if content[y][m].has(d-i):
						for duo in content[y][m][d-i].size():
							nr+=1
							words.append(content[y][m][d-i][duo])
			elif m==2:
				for i in range(28):
					if content[y][m].has(d-i):
						for duo in content[y][m][d-i].size():
							nr+=1
							words.append(content[y][m][d-i][duo])
		if (m==1 or m==3 or m==5 or m==7 or m==8 or m==10 or m==12) and d<=30 and content[y].has(m-1):
			for i in range(31-d):
				if content[y][m-1].has(31-i):
					for duo in content[y][m-1][31-i].size():
						nr+=1
						words.append(content[y][m-1][31-i][duo])
		elif (m==4 or m==6 or m==9 or m==11) and d<=29 and content[y].has(m-1):
			for i in range(31-d):
				if content[y][m-1].has(31-i):
					for duo in content[y][m-1][31-i].size():
						nr+=1
						words.append(content[y][m-1][31-i][duo])
		elif (m==3) and d<=27 and content[y].has(m-1):
			for i in range(28-d):
				if content[y][m-1].has(28-i):
					for duo in content[y][m-1][28-i].size():
						nr+=1
						words.append(content[y][m-1][28-i][duo])

	if m==1 and content.has(y-1):
		if content[y-1].has(12):
			for i in range(31-d):
				if content[y-1][12].has(31-i):
					for duo in content[y-1][12][31-i].size():
						nr+=1
						words.append(content[y-1][12][31-i][duo])
	return [nr,words]

func bb_give_me_words_from_full_content():
	var nr=0
	var words=[]
	if not content.empty():
		for year in content.keys():
			for month in content[year].keys():
				for day in content[year][month].keys():
					for duo in content[year][month][day]:
						nr+=1
						words.append(duo)
	return [nr,words]

func check_is_dou_already_in_memory(new_duo=["",""],change=false,loc=[1969,12,31,100]):
	if not content.empty():
		for y in content:
			for m in content[y]:
				for d in content[y][m]:
					var nr=0
					for duo in content[y][m][d]:
						if duo[0]==new_duo[0] or duo[0]==new_duo[1] or duo[1]==new_duo[0] or duo[1]==new_duo[1]:
							if change:
								if y==loc[0] and m==loc[1] and d==loc[2] and nr==loc[3]:
									pass
								else:
									return [true,d,m,y]
							else:
								return [true,d,m,y]
						nr+=1
	return [false]


func bb_days_in_real_month(m):
	var nr
	match m:
		1:
			nr =31
		2:
			nr =28
		3:
			nr =31
		4:
			nr =30
		5:
			nr =31
		6:
			nr =30
		7:
			nr =31
		8:
			nr =31
		9:
			nr =30
		10:
			nr =31
		11:
			nr =30
		12:
			nr =31
	return nr

func bb_print_month_name(nr):
	var month
	match nr:
		1:
			month ="January"
		2:
			month ="February"
		3:
			month ="March"
		4:
			month ="April"
		5:
			month ="May"
		6:
			month ="June"
		7:
			month ="July"
		8:
			month ="August"
		9:
			month ="September"
		10:
			month ="October"
		11:
			month ="November"
		12:
			month ="December"
	return month
