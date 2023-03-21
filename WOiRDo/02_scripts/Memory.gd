extends Control

export(NodePath) var MemoryTween
var memorytween
export(NodePath) var DayTween
var daytween
export(NodePath) var DuoTween
var duotween

var but_pressed=false
var delete_mode_changed=false

var month_package = preload("res://01_scenes/Month.tscn")
var wordlist_package = preload("res://01_scenes/From_day_month_year.tscn")


var month_on_screen=0

var wordlist_on_screen = null


func _ready():
	memorytween=get_node(MemoryTween)
	daytween=get_node(DayTween)
	duotween=get_node(DuoTween)
	visible=false
	$WordList.visible=false
	if Content.bb_give_me_nr_of_months()<2:
		bb_show_rl_buttons(false)
	bb_disable_backWLbutton(true)

	if not Content.content.empty():
		$Calendar/Month0.visible=false
		$DeleteDay.visible=true
	pass # Replace with function body.

func bb_swich_on_delete_day_mode(value):
	for day in $Calendar.get_node("Month%d/Days"%month_on_screen).get_children():
		day.delete_day_mode_on=value
	delete_mode_changed=value


var fake_date={"month":1,"day":1,"year":2022}

func bb_get_date():
	var fake_date_in_function=fake_date
	var real_date = OS.get_date()
	return real_date

func bb_store_word(word,meaning):
	var year=bb_get_date()["year"]
	var month=bb_get_date()["month"]
	var day=bb_get_date()["day"]

	if Content.content.empty():
		$Calendar/Month0.visible=false
		$DeleteDay.visible=true
	Content.bb_create_day(year,month,day)
	bb_check_month()
	yield(get_tree(), "idle_frame")
	bb_check_day(year,month,day)
	yield(get_tree(), "idle_frame")
	Content.bb_save_new_content(year,month,day,[word,meaning])
	var short = "From"+"_"+str(day)+"_"+str(month)+"_"+str(year)
	get_node("WordList/Content/"+short).bb_add_duo(word,meaning)
	bb_show_month(month_on_screen,true)
	print(word)
	print(meaning)
	
#	get_node("Calendar").get_children()[-1].bb_create_day()

func bb_correct_word(loc,word,meaning):
	Content.bb_correct_content(loc[0],loc[1],loc[2],loc[3],[word,meaning])
	var short = "From"+"_"+str(loc[2])+"_"+str(loc[1])+"_"+str(loc[0])
	get_node("WordList/Content/"+short).bb_change_duo(word,meaning,loc[3])

func bb_user_wants_to_delete_word(d,m,y,nr):
#	day_nr,month_nr,year_nr,(arg-1)
	Content.bb_delete_content(y,m,d,nr)
	wordlist_on_screen.bb_delete_duo(nr+1)
	Signals.emit_signal("save_content_on_hard_disk")



func bb_user_deleted_day(d,m,y):
	get_node("../MainAnim").play("05_hide_WordList_show_start")
	yield(get_node("../MainAnim"),"animation_finished")
	Content.bb_delete_day(y,m,d)
	
	var short = bb_find_month(m,y).get_node("Days/Day"+str(d))
	var short2 = get_node("WordList/Content/From"+"_"+str(d)+"_"+str(m)+"_"+str(y))
	short.queue_free()
	short2.queue_free()
	yield(get_tree(), "idle_frame")
	bb_should_whole_month_be_deleted(y,m)
	yield(get_tree(), "idle_frame")
	month_on_screen=Content.bb_give_me_nr_of_months()
	bb_rename_months()
	bb_show_month(Content.bb_give_me_nr_of_months(),true)
	delete_mode_changed=false
	Signals.emit_signal("save_content_on_hard_disk")


func bb_find_month(m,y):
	for month in get_node("Calendar").get_children():
		if not month.name=="Month0":
			if month.month_nr==m and month.year_nr==y:
				return month


func bb_should_whole_month_be_deleted(y,m):
	var short = bb_find_month(m,y)
	if short.get_node("Days").get_children().empty():
		if get_node("Calendar").get_children().size()==2:
			$Calendar/Month0.visible=true
			$DeleteDay.visible=false
		if get_node("Calendar").get_children().size()==3:
			bb_show_rl_buttons(false)
		Content.bb_delete_month(y,m)
		short.queue_free()

func bb_rename_months():
	for month in get_node("Calendar").get_children():
		if not month.name=="Month0":
			month.name="Z"
	var nr=0
	for month in get_node("Calendar").get_children():
		if not month.name=="Month0":
			nr+=1
			month.name="Month"+str(nr)




func bb_show_rl_buttons(value):
	$Right.visible=value
	$Left.visible=value

func bb_show_month(nr,value):
	get_node("Calendar").get_node("Month%d" %nr).visible=value



func bb_swipe_monts_visibility(direction):
	for day in $Calendar.get_node("Month%d/Days/"%month_on_screen).get_children():
		day.get_node("Button").disabled=true
	
	match direction:
		"right":
			month_on_screen+=1
			var nr_of_months=Content.bb_give_me_nr_of_months()
			if month_on_screen>nr_of_months:
				month_on_screen=1
				get_node("Calendar").get_node("Month%d" %nr_of_months).visible=false
				get_node("Calendar").get_node("Month%d" %month_on_screen).visible=true
			else:
				get_node("Calendar").get_node("Month%d" %(month_on_screen-1)).visible=false
				get_node("Calendar").get_node("Month%d" %month_on_screen).visible=true

		"left":
			month_on_screen-=1
			if month_on_screen==0:
				month_on_screen = Content.bb_give_me_nr_of_months()
				get_node("Calendar").get_node("Month%d" %1).visible=false
				get_node("Calendar").get_node("Month%d" %month_on_screen).visible=true
			else:
				get_node("Calendar").get_node("Month%d" %(month_on_screen+1)).visible=false
				get_node("Calendar").get_node("Month%d" %month_on_screen).visible=true
	
	for day in $Calendar.get_node("Month%d/Days/"%month_on_screen).get_children():
		day.get_node("Button").disabled=false


func bb_create_new_wordlist(d,m,y):
	var new_list = wordlist_package.instance()
	new_list.name = "From"+"_"+str(d)+"_"+str(m)+"_"+str(y)
	new_list.bb_start_params(d,m,y,duotween)
	get_node("WordList/Content").add_child(new_list)

func bb_create_new_month():
	var month = month_package.instance()
	month_on_screen+=1
	month.name="Month"+str(Content.bb_give_me_nr_of_months())
	month.bb_start_params(Content.bb_print_month_name(bb_get_date()["month"]),bb_get_date()["year"],daytween)
	$Calendar.add_child(month)

func bb_recreate_month(y,m,nr):
	$Calendar/Month0.visible=false
	$DeleteDay.visible=true
	var month = month_package.instance()
	month_on_screen+=1
	month.name="Month"+str(nr)
	month.bb_start_params(Content.bb_print_month_name(m),y,daytween)
	$Calendar.add_child(month)


func bb_recreate_day(y,m,d,nr):
	get_node("Calendar/Month%d"%nr).bb_create_day(d,m,y)
	bb_create_new_wordlist(d,m,y)

func bb_recreate_duo(y,m,d,word,meaning):
	var short = "From"+"_"+str(d)+"_"+str(m)+"_"+str(y)
	get_node("WordList/Content/"+short).bb_add_duo(word,meaning)


func bb_check_year():
	Content.bb_create_year(bb_get_date()["year"])


func bb_check_month():
	if (get_node("Calendar").get_children().size()-1)!=Content.bb_give_me_nr_of_months():
		bb_show_month(month_on_screen,false)
		bb_create_new_month()
		if Content.bb_give_me_nr_of_months()==2:
			bb_show_rl_buttons(true)

func bb_check_day(y,m,d):
	var month_picture = get_node("Calendar/Month"+str(Content.bb_give_me_nr_of_months()))
	var days_nr = month_picture.get_node("Days").get_children().size()
	if Content.bb_give_me_nr_of_days_in_month(y,m)!=days_nr:
		month_picture.bb_create_day(d,m,y)
		bb_create_new_wordlist(d,m,y)


func bb_disable_buttons_from_specific_wordlist(value):
	for list in $WordList/Content.get_children():
		if list.visible==true:
			list.bb_disable_all_buttons(false)

func bb_disable_buttons(value):
	get_node("Back").disabled=value
	$Right.disabled=value
	$Left.disabled=value
	$DeleteDay.disabled=value
	if $Calendar.get_children().size()>1:
		for day in $Calendar.get_node("Month%d/Days/"%month_on_screen).get_children():
			day.get_node("Button").disabled=value


func bb_disable_backWLbutton(value):
	get_node("WordList/BackFromWL").disabled=value

func bb_show_wordlist(value):
	get_node("WordList").visible=value

func bb_hide_wordlist_on_screen():
	wordlist_on_screen.rect_position=Vector2(0,0)
	wordlist_on_screen.visible=false
	wordlist_on_screen.delete_word_mode_on=false

func bb_user_wants_to_see_wordlist(d,m,y):
	get_node("../MainAnim").play("03_hide_memory_show_WordList")
	var short = "From"+"_"+str(d)+"_"+str(m)+"_"+str(y)
	wordlist_on_screen=get_node("WordList/Content/"+short)
	$WordList.wordlist_on_screen=wordlist_on_screen
	$WordList.temporary_borders=wordlist_on_screen.list_borders
	wordlist_on_screen.bb_check_if_LR_UD_buttonns_should_be_visible($WordList.temporary_borders[1]-50,wordlist_on_screen.nr_of_duos)
	wordlist_on_screen.visible=true


func _on_Back_button_down():
	but_pressed=true
	memorytween.bb_animate_pressing_button(1)
func _on_Back_button_up():
	if but_pressed:
		but_pressed=false
		memorytween.bb_animatation_stopped(1)
		get_node("../MainAnim").play("03_hide_memory_show_start")
		if delete_mode_changed:
			bb_swich_on_delete_day_mode(false)
func _on_Back_toggled(button_pressed):
	pass # Replace with function body.



func _on_BackFromWL_button_down():
	but_pressed=true
	memorytween.bb_animate_pressing_button(4)
func _on_BackFromWL_button_up():
	if but_pressed:
		but_pressed=false
		memorytween.bb_animatation_stopped(4)
		get_node("../MainAnim").play("05_hide_WordList_show_memory")
func _on_BackFromWL_toggled(button_pressed):
	pass # Replace with function body.

func _on_Right_button_down():
	but_pressed=true
	memorytween.bb_animate_pressing_button(2)
func _on_Right_button_up():
	if but_pressed:
		but_pressed=false
		memorytween.bb_animatation_stopped(2)
		if delete_mode_changed:
			bb_swich_on_delete_day_mode(false)
		bb_swipe_monts_visibility("right")
func _on_Right_toggled(button_pressed):
	pass # Replace with function body.

func _on_Left_button_down():
	but_pressed=true
	memorytween.bb_animate_pressing_button(3)
func _on_Left_button_up():
	if but_pressed:
		but_pressed=false
		memorytween.bb_animatation_stopped(3)
		if delete_mode_changed:
			bb_swich_on_delete_day_mode(false)
		bb_swipe_monts_visibility("left")
func _on_Left_toggled(button_pressed):
	pass # Replace with function body.




func _on_DeleteDay_button_down():
	but_pressed=true
	memorytween.bb_animate_pressing_button(6)
func _on_DeleteDay_button_up():
	if but_pressed:
		but_pressed=false
		if delete_mode_changed:
			bb_swich_on_delete_day_mode(false)
		memorytween.bb_animatation_stopped(6)
		Signals.emit_signal("show_warning6")
