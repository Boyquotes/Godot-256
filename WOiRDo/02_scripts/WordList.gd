extends Control

var sign_package = preload("res://06_resources/Sign/Sign.tscn")
var button_texture=preload("res://03_assets/button.png")
var texture_script=preload("res://02_scripts/TextureButton.gd")

export(NodePath) var MoveListTween
var moveListTween

var wordlist_on_screen

#var delete_word_mode_on = false
var but_pressed=false

#Variables for moving wordlins
var move_speed_max=1000
var move_speed_acceleration=2000
var temporary_move_speed=0
var direction=1
var acclelertion_mode=0
var temporary_borders=[]
var temporary_word_lenght=0
var temporary_border=0

func _ready():
	moveListTween=get_node(MoveListTween)
	set_process(false)


func _process(delta):
	match acclelertion_mode:
		0:
			pass
		1:
			bb_check_border1()
			bb_move_v_with_acceleration(delta)
		2:
			bb_check_border1()
			bb_move_v_and_slow_down(delta)
		3:
			bb_check_border2()
			bb_move_h_with_acceleration(delta)
		4:
			bb_check_border2()
			bb_move_h_and_slow_down(delta)

func show_LR_buttons(value):
	$MoveWordLR.visible=value

func show_UD_buttons(value):
	$MoveWordUD.visible=value

func bb_swich_on_delete_word_mode(value):
	wordlist_on_screen.delete_word_mode_on=value


func bb_check_border1():
	var right = temporary_borders[1]
	var left = temporary_borders[0]
	match direction:
		1:
			if (wordlist_on_screen.rect_position.x)>=left:
				set_process(false)
		-1:
			if (wordlist_on_screen.rect_position.x)<=right:
				set_process(false)


func bb_check_border2():
	var down = temporary_borders[3]
	var top = temporary_borders[2]
	match direction:
		1:
			if (wordlist_on_screen.rect_position.y)>=top:
				set_process(false)
		-1:
			if (wordlist_on_screen.rect_position.y)<=-down+1024:
				set_process(false)



func bb_move_v_with_acceleration(delta):
	if temporary_move_speed<=move_speed_max:
		temporary_move_speed += delta*move_speed_acceleration
	wordlist_on_screen.rect_position.x+=direction*temporary_move_speed*delta

func bb_move_v_and_slow_down(delta):
	if not temporary_move_speed<=0:
		temporary_move_speed -= delta*move_speed_acceleration
	else:
		set_process(false)
	wordlist_on_screen.rect_position.x+=direction*temporary_move_speed*delta

func bb_move_h_with_acceleration(delta):
	if temporary_move_speed<=move_speed_max:
		temporary_move_speed += delta*move_speed_acceleration
	wordlist_on_screen.rect_position.y+=direction*temporary_move_speed*delta

func bb_move_h_and_slow_down(delta):
	if not temporary_move_speed<=0:
		temporary_move_speed -= delta*move_speed_acceleration
	else:
		set_process(false)
	wordlist_on_screen.rect_position.y+=direction*temporary_move_speed*delta



func bb_reset_proces():
	set_process(false)
	acclelertion_mode=0
	temporary_move_speed=0

func _on_MoveWordlistRight_button_down():
	but_pressed=true
	moveListTween.bb_animate_pressing_button(4)
	bb_reset_proces()
	direction=-1
	acclelertion_mode=1
	set_process(true)
func _on_MoveWordlistRight_button_up():
	if but_pressed:
		but_pressed=false
		moveListTween.bb_animatation_stopped(4)
		acclelertion_mode=2
func _on_MoveWordlistRight_toggled(button_pressed):
	pass # Replace with function body.


func _on_MoveWordlistLeft_button_down():
	moveListTween.bb_animate_pressing_button(3)
	but_pressed=true
	bb_reset_proces()
	direction=1
	acclelertion_mode=1
	set_process(true)
func _on_MoveWordlistLeft_button_up():
	if but_pressed:
		but_pressed=false
		moveListTween.bb_animatation_stopped(3)
		acclelertion_mode=2
func _on_MoveWordlistLeft_toggled(button_pressed):
	pass # Replace with function body.


func _on_MoveWordlistUP_button_down():
	but_pressed=true
	moveListTween.bb_animate_pressing_button(1)
	bb_reset_proces()
	direction=1
	acclelertion_mode=3
	set_process(true)
func _on_MoveWordlistUP_button_up():
	if but_pressed:
		but_pressed=false
		moveListTween.bb_animatation_stopped(1)
		acclelertion_mode=4
func _on_MoveWordlistUP_toggled(button_pressed):
	pass # Replace with function body.


func _on_MoveWordlistDOWN_button_down():
	but_pressed=true
	moveListTween.bb_animate_pressing_button(2)
	bb_reset_proces()
	direction=-1
	acclelertion_mode=3
	set_process(true)
func _on_MoveWordlistDOWN_button_up():
	if but_pressed:
		but_pressed=false
		moveListTween.bb_animatation_stopped(2)
		acclelertion_mode=4
func _on_MoveWordlistDOWN_toggled(button_pressed):
	pass # Replace with function body.


func _on_DestroyWord_button_down():
	but_pressed=true
	get_parent().memorytween.bb_animate_pressing_button(5)
func _on_DestroyWord_button_up():
	if but_pressed:
		but_pressed=false
#		delete_word_mode_on = false
		bb_swich_on_delete_word_mode(false)
		get_parent().memorytween.bb_animatation_stopped(5)
		Signals.emit_signal("show_warning3")
func _on_DestroyWord_toggled(button_pressed):
	pass # Replace with function body.
