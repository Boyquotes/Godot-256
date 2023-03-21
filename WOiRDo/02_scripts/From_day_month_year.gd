extends Control

var sign_package
var button_texture
var texture_script

var duotween

var nr_of_duos=0
var nr_of_buttons=0
var day_nr
var month_nr
var year_nr

var delete_word_mode_on = false
var but_pressed=false

var sign_scale=0.25
var but_text_scale=1.2

# [left,right,top,down]
export var duo_vertical_space=120
export var letter_size=156
var letters_in_longest_duo = 0
var list_borders = [0,0,0,0]


func _ready():
	sign_package=get_node("../..").sign_package
	button_texture=get_node("../..").button_texture
	texture_script=get_node("../..").texture_script
	pass # Replace with function body.


func bb_start_params(day,m,y,tween):
	day_nr=day
	month_nr=m
	year_nr=y
	duotween=tween


func bb_add_duo(w="bob",m="kres"):
	nr_of_duos += 1
	var new_sign = sign_package.instance()
	new_sign.read_sign(w+" - "+m)
	new_sign.name = "Duo_nr_"+str(nr_of_duos)
	new_sign.rect_size = Vector2(0,0)
	add_child(new_sign)
	new_sign.rect_size.y = 256
	var size=new_sign.rect_size
	var pos = bb_get_word_pos(size)
	new_sign.rect_position=pos

	yield(get_tree(), "idle_frame")
	var texture=TextureRect.new()
	nr_of_buttons += 1
	texture.expand=true
	texture.set_stretch_mode(1)
	texture.texture=button_texture
	texture.name="Button_"+str(nr_of_buttons)
	texture.connect("gui_input",self,"bb_button_pressed",[nr_of_buttons])
	texture.rect_size=size*but_text_scale*sign_scale
	texture.rect_position=pos-(size*but_text_scale-size)*sign_scale/2
	texture.set_script(texture_script)
	$Buttons.add_child(texture)

	bb_recreate_list_borders(w,m)

func bb_get_word_pos(size):
	var y_pos=(nr_of_duos-1)*duo_vertical_space+50
	var x_pos=288-size.x*sign_scale/2
	return Vector2(x_pos,y_pos)

func bb_get_new_word_pos(size,nr):
	print(nr)
	var y_pos=(nr-1)*duo_vertical_space+50
	var x_pos=288-size.x*sign_scale/2
	return Vector2(x_pos,y_pos)

func bb_button_pressed(event,arg):
	if not get_node("Buttons/Button_"+str(arg)).disabled:
		if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
			if event.is_pressed():
#				print("pastuchy na obiad  "+str(arg))
				duotween.bb_animate_pressing_button(day_nr,month_nr,year_nr,arg)
				but_pressed=true
			if not event.is_pressed():
#				print("pierogi poszły na obiad")
				if but_pressed:
					but_pressed=false
					duotween.bb_animatation_stopped(day_nr,month_nr,year_nr,arg)
					match delete_word_mode_on:
						false:
							bb_disable_all_buttons(true)
							Signals.emit_signal("change_saved_word",day_nr,month_nr,year_nr,(arg-1))
						true:
							print("i am gonna to delet you! - " +str(arg))
							duotween.bb_reset_used_button_nr()
							Signals.emit_signal("delete_word",day_nr,month_nr,year_nr,(arg-1))
							delete_word_mode_on = false

func bb_disable_all_buttons(value):
	for but in $Buttons.get_children():
		but.disabled=value


func bb_delete_duo(nr):
	get_node("Duo_nr_"+str(nr)).queue_free()
	get_node("Buttons/Button_"+str(nr)).queue_free()
	nr_of_duos -= 1
	nr_of_buttons-=1
	if nr_of_duos==0:
		Signals.emit_signal("delete_day",day_nr,month_nr,year_nr)
	else:
		yield(get_tree(), "idle_frame")
		rect_position=Vector2.ZERO
		bb_rename_duos()
		bb_rename_buttons()
		bb_recreate_list_borders(0,0,true)

func bb_change_duo(w,m,nr):
	rect_position=Vector2(0,0)
	var duo_short=get_node("Duo_nr_"+str(nr+1))
	duo_short.read_sign(w+" - "+m)
	duo_short.rect_size = Vector2(0,0)
	duo_short.rect_size.y=256
	var size=duo_short.rect_size
	var pos = bb_get_new_word_pos(size,nr+1)
	duo_short.rect_position=pos

	var texture=get_node("Buttons/Button_"+str(nr+1))
	texture.rect_size=size*but_text_scale*sign_scale
	texture.rect_position=pos-(size*but_text_scale-size)*sign_scale/2

	bb_recreate_list_borders(0,0,true)


func bb_rename_duos():
	for duo in get_children():
		if not duo.name=="Buttons":
			duo.name="Z"
	var nr=0
	for duo in get_children():
		if not duo.name=="Buttons":
			nr+=1
			duo.name="Duo_nr_"+str(nr)
			duo.rect_position=bb_get_new_word_pos(duo.rect_size,nr)


func bb_rename_buttons():
	for button in $Buttons.get_children():
		button.name="Z"
		button.disconnect("gui_input",self,"bb_button_pressed")
	var nr=0
	for button in $Buttons.get_children():
		nr+=1
		button.name="Button_"+str(nr)
		var pos = get_node("Duo_nr_"+str(nr)).get("rect_position")
		var size = get_node("Duo_nr_"+str(nr)).get("rect_size")
		button.rect_position=pos-(size*but_text_scale-size)*sign_scale/2
		button.connect("gui_input",self,"bb_button_pressed",[nr])

func bb_recreate_list_borders(w,m,i_have_full_duo=false):
	var right
	var left
	var bot
	match i_have_full_duo:
		false:
			var new_duo_length = LettersAndNumbers.bb_length((w+" - "+m))
			if new_duo_length>letters_in_longest_duo or nr_of_duos==1:
				letters_in_longest_duo=new_duo_length
		true:
			letters_in_longest_duo = 0
			for duo in get_children():
				if not duo.name=="Buttons":
					if LettersAndNumbers.bb_length(duo.word_on_screen)>letters_in_longest_duo:
						letters_in_longest_duo=LettersAndNumbers.bb_length(duo.word_on_screen)
	right = (576-letter_size*letters_in_longest_duo *0.25)/2-100
	left = -right
	bot=nr_of_duos*duo_vertical_space+300
	list_borders=[left,right,100,bot]
	get_node("../..").temporary_borders=list_borders
	bb_check_if_LR_UD_buttonns_should_be_visible(right,nr_of_duos)

func bb_check_if_LR_UD_buttonns_should_be_visible(size,size_up):
	if size<-100:
		get_node("../..").show_LR_buttons(true)
	elif size>=-100:
		get_node("../..").show_LR_buttons(false)
	if size_up>7:
		get_node("../..").show_UD_buttons(true)
	else:
		get_node("../..").show_UD_buttons(false)
