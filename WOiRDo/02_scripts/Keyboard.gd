extends Control

export(NodePath) var keyboardtween

var but_pressed=false

var mode=0 setget set_mode

var origin_key_placement=[]
var shafled_key_placement=[]
var standard_letters=["Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","0","Z","X","C","V","B","N","M"," "]


func _ready():
	visible=false
	for but in $Buttons.get_children():
		origin_key_placement.append(but.rect_position)

	var button_nr=0
	for but in $Buttons.get_children():
		but.connect("gui_input",self,"bb_button_input",[button_nr,standard_letters[button_nr]])
		button_nr+=1


func bb_button_input(event,nr,letter):
	
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if event.is_pressed():
#			print("Button down: " +str(letter))
			but_pressed=true
			get_node(keyboardtween).bb_animate_pressing_button(nr)
		if not event.is_pressed():
#			print("Button up: " +str(letter))
			if but_pressed:
				but_pressed=false
				match mode:
					0:
						Signals.emit_signal("letter_poked",letter)
					1:
						Signals.emit_signal("letter_poked_in_quest",letter)
				get_node(keyboardtween).bb_animatation_stopped(nr)



func set_mode(value):
	mode=value
	get_node("../SpecialKeyboard").mode=value
	match mode:
		0:
			print("MODE 0 on")
			for i in $Buttons.get_children().size():
				$Buttons.get_child(i).rect_position=origin_key_placement[i]
		1:
			pass
#			bb_shufle_key_placement()


func bb_shufle_key_placement():
	get_node(keyboardtween).bb_reset_tween()
	but_pressed=false
	shafled_key_placement=[]
	randomize()
	var copy=origin_key_placement.duplicate()
	var nr=origin_key_placement.size()
	for i in origin_key_placement.size():
		var random_place = randi()%nr
		shafled_key_placement.append(copy[random_place])
		copy.remove(random_place)
		nr-=1
	for i in $Buttons.get_children().size():
		$Buttons.get_child(i).rect_position=shafled_key_placement[i]



func _on_DEL_gui_input(event):
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if event.is_pressed():
			but_pressed=true
			get_node(keyboardtween).bb_animate_pressing_button(100)
		if not event.is_pressed():
			if but_pressed:
				but_pressed=false
				match mode:
					0:
						Signals.emit_signal("remove_last_letter")
					1:
						Signals.emit_signal("remove_last_letter_in_quest")
				get_node(keyboardtween).bb_animatation_stopped(100)


func _on_ShowSpecial_gui_input(event):
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if event.is_pressed():
			but_pressed=true
			get_node(keyboardtween).bb_animate_pressing_button(101)
		if not event.is_pressed():
			if but_pressed:
				but_pressed=false
				Signals.emit_signal("show_special_keybord")
				get_node(keyboardtween).bb_animatation_stopped(101)
