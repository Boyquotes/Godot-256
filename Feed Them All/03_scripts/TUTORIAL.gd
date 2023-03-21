extends Node2D

signal get_out_off_tuto

signal show_next_advice

#############################
#  MAIN SIGNALS #############
#############################
signal start_advice_nr0
var tutorial_step = 0
var start_line = Vector2.ZERO


onready var anim = $AnimPlayer
onready var tutotween = $TutoTween
onready var hand = $Plate/Background/Hand
onready var main = $Plate/Background/Main
onready var get_main_scene = get_tree().get_root().get_node("Main")

func _ready():
	set_physics_process(false)
	connect("show_next_advice",self,"show_advice")
	connect("get_out_off_tuto",get_main_scene,"_end_tuto")

func _physics_process(delta):
	if tutorial_step==7:
		if Input.is_action_just_released("mouse_left"):
			SettingTarget.draging = false
			SettingTarget.update()
			var point = get_global_mouse_position()
#			if point.x<420 and point.x>400 && point.y<490 and point.y>470:
			if point.x<450 and point.x>350 && point.y<650 and point.y>550:
				pass
			else:
				tutorial_step=5
				emit_signal("show_next_advice",tutorial_step)
	if tutorial_step==8:
		if Input.is_action_just_released("mouse_left"):
			SettingTarget.draging = false
			SettingTarget.update()
			var point = get_global_mouse_position()
#			if point.x<420 and point.x>400 && point.y<490 and point.y>470:
			if point.x<450 and point.x>350 && point.y<650 and point.y>550:
				emit_signal("show_next_advice",tutorial_step)
			else:
				tutorial_step=5
				emit_signal("show_next_advice",tutorial_step)

func _on_Background_gui_input(event):
	var point = get_global_mouse_position()
	if tutorial_step==7:
		if event is InputEventMouseMotion:
			SettingTarget.line_start = start_line
			SettingTarget._target_for_totorial(event)
#			if point.x<420 and point.x>400 && point.y<490 and point.y>470:
			if point.x<450 and point.x>350 && point.y<650 and point.y>550:
				emit_signal("show_next_advice",tutorial_step)

	if tutorial_step==8:
		if event is InputEventMouseMotion:
			SettingTarget.line_start = start_line
			SettingTarget._target_for_totorial(event)
#			if point.x<420 and point.x>400 && point.y<490 and point.y>470:
			if point.x<450 and point.x>350 && point.y<650 and point.y>550:
				hand.play("touch",true)
				$Plate/Background/Main/nr_6.hide()
				$Plate/Background/Main/nr_7.show()
			else:
				$Plate/Background/Main/nr_6.show()
				$Plate/Background/Main/nr_7.hide()
				hand.stop()
				hand.frame = 4

	if tutorial_step==6:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.is_pressed():
#				if point.x<420 and point.x>400 && point.y<390 and point.y>370:
				if point.x<440 and point.x>380 && point.y<410 and point.y>350:
					start_line = get_global_mouse_position()
					emit_signal("show_next_advice",tutorial_step)
					SettingTarget.draging = true
	pass # Replace with function body.

func _on_TutoriaBack_button_down():
	$Plate/Background/TutoriaBack.rect_position.y = 665
func _on_TutoriaBack_button_up():
	$Plate/Background/TutoriaBack.rect_position.y = 655
func _on_TutoriaBack_toggled(button_pressed):
	emit_signal("get_out_off_tuto")


func activate_tutorialbackbutton(value):
	$Plate/Background/TutoriaBack.disabled = not value

func activate_tutorialnextbutton(value):
	$Plate/Background/NextButton.disabled = not value
	if value:
		$Plate/Background/NextButton.show()
	else:
		$Plate/Background/NextButton.hide()

func advice_nr0():
	$Plate/Background/Main/nr_0.show()
	tutorial_step +=1
	activate_tutorialnextbutton(true)
	anim.play("Next")

func advice_nr1():
	tutorial_step +=1
	$Plate/Background/Main/nr_0.hide()
	get_main_scene._tuto_show_enemy()
	$Plate/Background/Main/nr_1.show()
func advice_nr2():
	tutorial_step +=1
	$Plate/Background/Main/nr_1.hide()
	get_main_scene._tuto_show_turtleys()
	$Plate/Background/Main/nr_2.show()
func advice_nr3():
	tutorial_step +=1
	tutotween.interpolate_property(hand, "position",
		hand.position, Vector2(100,80), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.interpolate_property(main, "rect_position",
		main.rect_position, Vector2(20,172), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.start()
	activate_tutorialbackbutton(false)
	activate_tutorialnextbutton(false)
	yield(tutotween,"tween_completed")
	activate_tutorialbackbutton(true)
	hand.play("tap")
	get_main_scene.get_node("Interface").specific_button_activate(true,0)
	$Plate/Background/Main/nr_2.hide()
	$Plate/Background/Main/nr_3.show()



func advice_nr4():
	hand.frame = 0
	get_main_scene.get_node("Interface").specific_button_activate(false,0)
	$Plate/Background/Main/nr_3.hide()
	tutorial_step +=1
	hand.stop()
	activate_tutorialbackbutton(false)
	tutotween.interpolate_property(hand, "position",
		Vector2(100,80), Vector2(100,170), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.interpolate_property($Plate/Background/Main, "rect_position",
		$Plate/Background/Main.rect_position, Vector2(20,252), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.start()
	yield(tutotween,"tween_completed")
	activate_tutorialbackbutton(true)
	hand.play("tap")
	get_main_scene.set_state(1)
#	$Plate/Background.mouse_filter = Control.MOUSE_FILTER_STOP
	$Plate/Background/Main/nr_4.show()



func advice_nr5():
	$Plate/Background/Main/nr_4.hide()
	$Plate/Background/Main/nr_6.hide()
	$Plate/Background/Main/nr_7.hide()
	get_main_scene.set_state(0)
	hand.stop()
	hand.frame = 0
	tutorial_step +=1
	activate_tutorialbackbutton(false)
	tutotween.interpolate_property(hand, "position",
		hand.position, Vector2(430,400), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.start()
	yield(tutotween,"tween_completed")
	$Plate/Background/Main/nr_6.hide()
	$Plate/Background/Main/nr_7.hide()
	hand.play("touch")
	yield(hand,"animation_finished")
	$Plate/Background/Main/nr_6.hide()
	$Plate/Background/Main/nr_7.hide()
	activate_tutorialbackbutton(true)
	$Plate/Background/Main/nr_5.show()
	$Plate/Background.mouse_filter = Control.MOUSE_FILTER_STOP
	pass


func advice_nr6():
	set_physics_process(true)
	$Plate/Background/Main/nr_5.hide()
	$Plate/Background/Main/nr_7.hide()
	tutorial_step +=1
	activate_tutorialbackbutton(false)
	tutotween.interpolate_property(hand, "position",
		Vector2(430,400), Vector2(430,600), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.start()
	yield(tutotween,"tween_completed")
	if not tutorial_step > 7:
		$Plate/Background/Main/nr_6.show()


func advice_nr7():
	#$Plate/Background/Main/nr_6.hide()
	hand.play("touch",true)
	tutorial_step +=1
	#$Plate/Background/Main/nr_7.show()


func advice_nr8():
	tutorial_step +=1
	hand.stop()
	hand.frame = 0
	$Plate/Background/Main/nr_5.hide()
	$Plate/Background/Main/nr_6.hide()
	$Plate/Background/Main/nr_7.hide()
	$Plate/Background/Main.rect_position = Vector2(20,72)
	$Plate/Background/Main/nr_8.show()
	set_physics_process(false)
	$Plate/Background.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var unit = get_main_scene.get_node("Units/Blue").get_child(0)
	unit.state_machine.get_node("MoveToSpecificTargetState/MoveToSpecificTarget").target = Vector2(400,450)
	unit.state_machine.change_state_to("MoveToSpecificTargetState")
	unit.activate_collision_areas()
	tutotween.interpolate_property(hand, "position",
		hand.position, Vector2(200,500), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.start()
	yield(tutotween,"tween_completed")
	activate_tutorialbackbutton(true)

func advice_nr9():
	tutorial_step +=1
	hand.stop()
	hand.frame = 0
	$Plate/Background/Main/nr_8.hide()
	$Plate/Background/Main/nr_9.show()
	activate_tutorialbackbutton(false)
	var enemy = get_main_scene.get_node("Enemies").get_child(0)
	enemy.state_machine.change_state_to("SwimmingState")
	if not get_main_scene.get_node("Enemies").get_children().empty():
		yield(get_main_scene.get_node("Enemies"),"no_enemies")
	get_main_scene.wash_units_from_previous_game()
	activate_tutorialbackbutton(true)
	activate_tutorialnextbutton(true)
	anim.play("Next")

func advice_nr10():
	activate_tutorialbackbutton(false)
	activate_tutorialnextbutton(false)
	tutorial_step +=1
	$Plate/Background/Main/nr_9.hide()
	$Plate/Background/Main/nr_10.show()
	get_main_scene._tuto_show_enemy(1,true,Vector2(100,675))
	get_main_scene._tuto_show_enemy(2,true,Vector2(250,675))
	get_main_scene._tuto_show_enemy(3,true,Vector2(400,675))
	yield(get_tree().create_timer(2.5),"timeout")
	activate_tutorialbackbutton(true)
	activate_tutorialnextbutton(true)
	anim.play("Next")

func advice_nr11():
	tutorial_step +=1
	$Plate/Background/Main/nr_10.hide()
	$Plate/Background/Main/nr_11.show()
	get_main_scene.spawn_unit_for_tuto(Vector2(100,425) , 0)
	get_main_scene.spawn_unit_for_tuto(Vector2(100,225) , 0)
	get_main_scene.spawn_unit_for_tuto(Vector2(250,425) , 0)
	get_main_scene.spawn_unit_for_tuto(Vector2(390,425) , 90)
	get_main_scene.spawn_unit_for_tuto(Vector2(250,350) , 0)
	get_main_scene.spawn_unit_for_tuto(Vector2(250,150) , 0)
	get_main_scene.spawn_unit_for_tuto(Vector2(410,350) , -90)
	var enemies = get_main_scene.get_node("Enemies").get_children()
	for enemy in enemies:
		enemy.state_machine.change_state_to("SwimmingState")
	activate_tutorialnextbutton(false)

func advice_nr12():
	tutorial_step +=1
	$Plate/Background/Main/nr_11.hide()
	$Plate/Background/Main/nr_12.show()
	activate_tutorialbackbutton(false)
	tutotween.interpolate_property(hand, "position",
		hand.position, Vector2(50,100), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.start()
	yield(tutotween,"tween_completed")
	hand.play("tap")
	activate_tutorialbackbutton(true)
	activate_tutorialnextbutton(true)
	anim.play("Next")

func advice_nr13():
	tutorial_step +=1
	activate_tutorialnextbutton(false)
	$Plate/Background/Main/nr_12.hide()
	$Plate/Background/Main/nr_13.show()
	get_main_scene.get_node("Interface").get_node("AnimPlayer").play("Intuto_clear_on")
	tutotween.interpolate_property(hand, "position",
		hand.position, Vector2(60,590), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.start()
	activate_tutorialbackbutton(false)
	yield(tutotween,"tween_completed")
	activate_tutorialnextbutton(true)
	activate_tutorialbackbutton(true)

func advice_nr14():
	tutorial_step +=1
	activate_tutorialnextbutton(false)
	$Plate/Background/Main/nr_13.hide()
	$Plate/Background/Main/nr_14.show()
	
	for unit in get_main_scene.get_node("Units/Blue").get_children():
		unit.state_machine.change_state_to("TutorialState")
	tutotween.interpolate_property(hand, "position",
		hand.position, Vector2(60,550), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tutotween.start()
	activate_tutorialbackbutton(false)
	yield(tutotween,"tween_completed")
	hand.play("tap")
	activate_tutorialnextbutton(true)
	activate_tutorialbackbutton(true)

func advice_nr15():
	tutorial_step +=1
	$Plate/Background/Main/nr_14.hide()
	$Plate/Background/Main/nr_15.show()
	hand.stop()

func advice_nr16():
	tutorial_step +=1
	$Plate/Background/Main/nr_15.hide()
	activate_tutorialnextbutton(false)
	activate_tutorialbackbutton(false)
	get_main_scene.get_node("Interface/AnimPlayer").play("In_tuto_clear_off")
	get_main_scene.get_node("Interface/Clear").disabled = true
	yield(get_tree().create_timer(1),"timeout")
	$Plate/Background/Main/nr_16.show()
	activate_tutorialnextbutton(true)
	activate_tutorialbackbutton(true)

func end_tutorial():
	get_main_scene._end_tuto()

func show_advice(step):
	match step:
		1:
			advice_nr1()
		2:
			advice_nr2()
		3:
			advice_nr3()
		4:
			advice_nr4()
		5:
			advice_nr5()
		6:
			advice_nr6()
		7:
			advice_nr7()
		8:
			advice_nr8()
		9:
			advice_nr9()
		10:
			advice_nr10()
		11:
			advice_nr11()
		12:
			advice_nr12()
		13:
			advice_nr13()
		14:
			advice_nr14()
		15:
			advice_nr15()
		16:
			advice_nr16()
		17:
			end_tutorial()

func _on_NextButton_button_down():
	$Plate/Background/NextButton.rect_position.y = 510
func _on_NextButton_button_up():
	$Plate/Background/NextButton.rect_position.y = 500
	emit_signal("show_next_advice", tutorial_step)
