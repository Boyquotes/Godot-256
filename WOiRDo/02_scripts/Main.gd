extends Control

export(Script) var game_save_class



func _input(event):
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if event.is_pressed():
#			print(get_global_mouse_position())
			pass
	if event is InputEventKey and event.scancode==KEY_SPACE:
		if event.is_pressed():
			get_node("Memory/WordList/Content").get_child(0).bbb_add_duo()
#			$Screen.bb_errase_unnecessary_spaces()
#			print(Content.get("content"))
#			print(Content.bb_give_me_nr_of_months())
#			print($Memory.fake_date)
	if event is InputEventKey and event.scancode==KEY_Z:
		if event.is_pressed():
			$Memory.fake_date["day"] += 1
	if event is InputEventKey and event.scancode==KEY_X:
		if event.is_pressed():
			$Memory.fake_date["month"] += 1
	if event is InputEventKey and event.scancode==KEY_C:
		if event.is_pressed():
			$Memory.fake_date["year"] += 1
	if event is InputEventKey and event.scancode==KEY_A:
		if event.is_pressed():
			$Memory.fake_date["day"] -= 1
	if event is InputEventKey and event.scancode==KEY_S:
		if event.is_pressed():
			$Memory.fake_date["month"] -= 1
	if event is InputEventKey and event.scancode==KEY_D:
		if event.is_pressed():
			$Memory.fake_date["year"] -= 1
	if event is InputEventKey:
		if event.is_pressed():
			pass
#			print($Memory.fake_date)


func _ready():
#	bb_load_content()
	$MainAnim.play("00_StartAnim")
	_load_stats()
	get_node("Black").visible=true
	get_node("Black").modulate=Color(0,0,0,0)
	bb_connect_signals()


func bb_connect_signals():
	#StartScreen
	Signals.connect("show_warning7",$Warnings,"bb_show_warning7")
	#Screen
	Signals.connect("save_word",$Memory,"bb_store_word")
	Signals.connect("correct_word",$Memory,"bb_correct_word")
	Signals.connect("show_warning1",$Warnings,"bb_show_warning1")
	Signals.connect("show_warning2",$Warnings,"bb_show_warning2")
#	Signals.connect("save_content_on_hard_disk",self,"bb_save_content_on_hard_disc")
	Signals.connect("save_content_on_hard_disk",self,"save_stats")
	Signals.connect("show_warning5",$Warnings,"bb_show_warning5")
	#Chalange/PickMode
	Signals.connect("show_warning4",$Warnings,"bb_show_warning4")
	#Keyboard
	Signals.connect("letter_poked",$Screen,"bb_add_letter")
	Signals.connect("remove_last_letter",$Screen,"bb_remove_last_letter")
	Signals.connect("letter_poked_in_quest",$Chalange/Arena,"bb_add_letter_in_quest")
	Signals.connect("remove_last_letter_in_quest",$Chalange/Arena,"bb_remove_last_letter_in_quest")
	Signals.connect("show_special_keybord",self,"bb_show_special_keyboard",[true])
	#SpecialKeyboard
	Signals.connect("hide_special_keybord",self,"bb_show_special_keyboard",[false])
	#Memory
	Signals.connect("show_warning6",$Warnings,"bb_show_warning6")
	#Memory/Calendar/Month_/Days/Day1
	Signals.connect("show_words_from_day",$Memory,"bb_user_wants_to_see_wordlist")
	Signals.connect("delete_whole_day",$Memory,"bb_user_deleted_day")
	#Memory/Wordlist
	Signals.connect("show_warning3",$Warnings,"bb_show_warning3")
	#Memory/Wordlist/Content/Buttons/Button
	Signals.connect("change_saved_word",self,"bb_user_wants_to_change_word")
	Signals.connect("delete_word",$Memory,"bb_user_wants_to_delete_word")
	Signals.connect("delete_day",$Memory,"bb_user_deleted_day")
	#Warnings/Warning3
	Signals.connect("swich_on_delete_word_mode",$Memory/WordList,"bb_swich_on_delete_word_mode")
	Signals.connect("swich_on_delete_day_mode",$Memory,"bb_swich_on_delete_day_mode")
	#Warnings/Warning5
	Signals.connect("user_still_wants_to_save_it",$Screen,"bb_save_woirdo")





func bb_show_screen(value):
	$Screen.visible=value
	$Keyboard.visible=value
	$SpecialKeyboard.visible=false

func bb_show_keyboard(value):
	$Keyboard.visible=value
	$SpecialKeyboard.visible=false
	$SpecialKeyboard/Language.visible=false

func bb_show_special_keyboard(value):
	$SpecialKeyboard.visible=value

func bb_show_start(value):
	$StartScreen.visible=value

func bb_show_memory(value):
	$Memory.visible=value

func bb_show_chalange(value):
	$Chalange.visible=value

func bb_show_startVideo(value):
	$StartVideo.visible=value

func bb_user_wants_to_change_word(d,m,y,nr):
#	print(str(d)+"____"+str(m)+"____"+str(y)+"____"+str(nr)+"____")
	$Screen.bb_change_word_mode(d,m,y,nr)
	$MainAnim.play("03_hide_memory_show_Screen")


###################
### SAVE SYSTEM ###
###################

const SAVE_DIR = "res://08_Savings/"
#const SAVE_DIR = "user://"

func bb_save_content_on_hard_disc():
	var dir = Directory.new()
	var data = Content.get("content")
	var save_slot = SAVE_DIR + "words.dat"

	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	if dir.dir_exists(save_slot):
		dir.remove(save_slot)

	var file = File.new()
	var error = file.open(save_slot,File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()


func bb_load_content():
	var file = File.new()
	var path = SAVE_DIR + "words.dat"
	if file.file_exists(path):
		var error = file.open(path, File.READ)
		if error == OK:
			var world_data = file.get_var()
			var load_content={}
			for year in world_data.keys():
				load_content[year]={}
				var month_order_nr=0
				for month in world_data[year].keys():
					load_content[year][month]={}
					month_order_nr+=1
					$Memory.bb_recreate_month(year,month,month_order_nr)
#					yield(get_tree(),"idle_frame")
					for day in world_data[year][month].keys():
						$Memory.bb_recreate_day(year,month,day,month_order_nr)
#						yield(get_tree(),"idle_frame")
						load_content[year][month][day]=[]
						for duo in world_data[year][month][day]:
							load_content[year][month][day].append(duo)
							$Memory.bb_recreate_duo(year,month,day,duo[0],duo[1])
#							yield(get_tree(),"idle_frame")
#							yield(get_tree(),"idle_frame")
			Content.content=load_content
			$Memory.bb_show_month($Memory.month_on_screen,true)
			if Content.bb_give_me_nr_of_months()>=2:
				$Memory.bb_show_rl_buttons(true)


### END SAVE SYSTEM ###
###################


###################
### SAVE SYSTEM_V2 ###
func save_stats():

	Content.nr_of_woirdos=Content.bb_give_me_words_from_full_content()[0]
	
#	print(Content.get("content"))
	var new_save = game_save_class.new()
	new_save.Saved_Content= Content.get("content")
	new_save.nr_of_words = Content.nr_of_woirdos
	new_save.Saved_Achivements = Content.achivements
#	new_save.Keyboard_Language = $SpecialKeyboard.language
	ResourceSaver.save("user://MySavings.res", new_save)
#	ResourceSaver.save("res://08_Savings/MySavings.tres", new_save)


var save_vars = ["Saved_Content"]

func verfy_save(saved_score):
	if saved_score.get(save_vars[0]) == null:
		print("error verfy save")
		return false
	return true

func _load_stats():
	var dir = Directory.new()
	if not dir.file_exists("user://MySavings.res"):
#	if not dir.file_exists("res://08_Savings/MySavings.tres"):
		return false
	var saved_stats = load("user://MySavings.res")
#	var saved_stats = load("res://08_Savings/MySavings.tres")
	if not verfy_save(saved_stats):
		return false
	var world_data = saved_stats.Saved_Content
	var achi_data = saved_stats.Saved_Achivements
	var lang_data = saved_stats.Keyboard_Language
	Content.achivements=achi_data
	Content.nr_of_woirdos=saved_stats.nr_of_words

	$SpecialKeyboard.bb_activate_language(lang_data)

#	$LoadScreen.bb_update_node(saved_stats.nr_of_words)

	if not world_data.empty():
		var load_content={}
		var words_nr_loaded=0
		for year in world_data.keys():
			load_content[year]={}
			var month_order_nr=0
			for month in world_data[year].keys():
				load_content[year][month]={}
				month_order_nr+=1
				$Memory.bb_recreate_month(year,month,month_order_nr)
				for day in world_data[year][month].keys():
					$Memory.bb_recreate_day(year,month,day,month_order_nr)
					load_content[year][month][day]=[]
					for duo in world_data[year][month][day]:
						load_content[year][month][day].append(duo)
						$Memory.bb_recreate_duo(year,month,day,duo[0],duo[1])
						words_nr_loaded+=1
	#					yield(get_tree(), "idle_frame")
#						yield(get_tree(), "idle_frame")
#						$LoadScreen.bb_update_progress(words_nr_loaded)

#						print(words_nr_loaded)
		Content.content=load_content
		$Memory/DeleteDay.visible=true
		$Memory.bb_show_month($Memory.month_on_screen,true)
		if Content.bb_give_me_nr_of_months()>=2:
			$Memory.bb_show_rl_buttons(true)
#	$LoadScreen.visible=false


### END SAVE SYSTEM_V2###
#########################







