extends Control

onready var get_main_scene = get_tree().get_root().get_node("Main")
signal spawn
signal update
signal game_paused
signal units_back_to_base

onready var tween_squize = $TweenSquize
var squize_time_multiplyier = 1
var tutorial_mode = false

func _ready():
	#$Anim.play("RiverFlow")
	for x in get_node("TopMenus").get_children().size():
		get_node("TopMenus").get_child(x).get_child(0).get_child(1).text = String(get_main_scene.avaible_units[x])
	connect("spawn",get_main_scene,"_spawn_unit")
	connect("update",get_main_scene,"_update_number")
	connect("game_paused",get_main_scene,"_game_paused")
	connect("units_back_to_base",get_main_scene,"_send_units_back_to_base")
	pass # Replace with function body.

func update_number(value: int):
	yield(get_tree(), "idle_frame")
	get_node("TopMenus").get_child(value).get_child(0).get_child(1).text = String(get_main_scene.avaible_units[value])

#### BUTTONS SIGNALS #############

func _on_Blue_button_down():
	$TopMenus/Control/Blue.rect_position.y = 10
	$TopMenus/Control2/Yellow.rect_position.y = 10
	$TopMenus/Control3/Green.rect_position.y = 10
	$Boxes.position.y = 3
	squize_box_befor_taking_unit(0)
	$Tree.position.y = -10
	$Boxes/BoxFoUnits.squize_units_befor_taking_one()
func _on_Blue_button_up():
	$TopMenus/Control/Blue.rect_position.y = 0
	$TopMenus/Control2/Yellow.rect_position.y = 0
	$TopMenus/Control3/Green.rect_position.y = 0
	$Boxes.position.y = 0
	$TopMenus/Control/Blue.rect_position.x = 0
	$TopMenus/Control/Blue.rect_scale.x = 1
	$Tree.position.y = -13
	randomize()
	match tutorial_mode:
		false:
			emit_signal("spawn", 0,Vector2(rand_range(40, 120),rand_range(110, 150)*squize_time_multiplyier),squize_time_multiplyier)
		true:
			emit_signal("spawn", 0,Vector2(80,140),squize_time_multiplyier,true)
			get_main_scene.get_node("TUTORIAL").emit_signal("show_next_advice",get_main_scene.get_node("TUTORIAL").tutorial_step)
	emit_signal("update",0)
	update_number(0)
	$Boxes/BoxFoUnits.stop_squizing_units()
	stop_squize_box(0)


func _on_Yellow_button_down():
	$TopMenus/Control/Blue.rect_position.y = 10
	$TopMenus/Control2/Yellow.rect_position.y = 10
	$TopMenus/Control3/Green.rect_position.y = 10
	$Boxes.position.y = 3
	squize_box_befor_taking_unit(1)
	$Tree.position.y = -10
	$Boxes/BoxFoUnits2.squize_units_befor_taking_one()
func _on_Yellow_button_up():
	$TopMenus/Control/Blue.rect_position.y = 0
	$TopMenus/Control2/Yellow.rect_position.y = 0
	$TopMenus/Control3/Green.rect_position.y = 0
	$Boxes.position.y = 0
	$TopMenus/Control2/Yellow.rect_position.x = 0
	$TopMenus/Control2/Yellow.rect_scale.x = 1
	$Tree.position.y = -13
	randomize()
	match tutorial_mode:
		false:
			emit_signal("spawn", 1,Vector2(rand_range(200, 280),rand_range(110, 150)*squize_time_multiplyier),squize_time_multiplyier)
		true:
			emit_signal("spawn", 1,Vector2(280,140),squize_time_multiplyier,true)
			get_main_scene.get_node("TUTORIAL").emit_signal("show_next_advice",get_main_scene.get_node("TUTORIAL").tutorial_step)
	emit_signal("update",1)
	update_number(1)
	$Boxes/BoxFoUnits2.stop_squizing_units()
	stop_squize_box(1)

func _on_Green_button_down():
	$TopMenus/Control/Blue.rect_position.y = 10
	$TopMenus/Control2/Yellow.rect_position.y = 10
	$TopMenus/Control3/Green.rect_position.y = 10
	$Boxes.position.y = 3
	squize_box_befor_taking_unit(2)
	$Tree.position.y = -10
	$Boxes/BoxFoUnits3.squize_units_befor_taking_one()
func _on_Green_button_up():
	$TopMenus/Control/Blue.rect_position.y = 0
	$TopMenus/Control2/Yellow.rect_position.y = 0
	$TopMenus/Control3/Green.rect_position.y = 0
	$Boxes.position.y = 0
	$TopMenus/Control3/Green.rect_position.x = 0
	$TopMenus/Control3/Green.rect_scale.x = 1
	$Tree.position.y = -13
	randomize()
	match tutorial_mode:
		false:
			emit_signal("spawn", 2,Vector2(rand_range(340, 420),rand_range(110, 150)*squize_time_multiplyier),squize_time_multiplyier)
		true:
			emit_signal("spawn", 2,Vector2(340,140),squize_time_multiplyier,true)
			get_main_scene.get_node("TUTORIAL").emit_signal("show_next_advice",get_main_scene.get_node("TUTORIAL").tutorial_step)
	emit_signal("update",2)
	update_number(2)
	$Boxes/BoxFoUnits3.stop_squizing_units()
	stop_squize_box(2)



func _on_Pause_button_down():
	$Pause_loc/Pause.rect_position.y = 20
func _on_Pause_button_up():
	$Pause_loc/Pause.rect_position.y = 0
	emit_signal("game_paused")


func _on_Clear_button_down():
	$Clear.rect_position.y = 500
func _on_Clear_button_up():
	$Clear.rect_position.y = 490
	emit_signal("units_back_to_base")

func show_vacuum_():
	$Clear.show()
func show_vacuum_and_pause_button():
	$Clear.show()
	$Pause_loc.show()
	$LevelNumber.show()
func show_tree():
	$Tree.visible = true
func hide_vacuum_and_pause_button():
	$Clear.hide()
	$Pause_loc.hide()
	$LevelNumber.hide()
func hide_tree():
	$Tree.visible = false
func disabled_vacuum_and_pause_button():
	$Clear.disabled=true
	$Pause_loc/Pause.disabled=true
func activate_vacuum():

	$Clear.disabled=false
func activate_vacuum_and_pause_button():
	yield(get_tree().create_timer(0.5),"timeout")
	$Clear.disabled=false
	$Pause_loc/Pause.disabled=false
func show_label_with_number_of_avaible_units():
	$TopMenus/Control3/Green/Label.show()
	$TopMenus/Control2/Yellow/Label.show()
	$TopMenus/Control/Blue/Label.show()
func hide_label_with_number_of_avaible_units():
	$TopMenus/Control3/Green/Label.hide()
	$TopMenus/Control2/Yellow/Label.hide()
	$TopMenus/Control/Blue/Label.hide()
func show_boxes_content():
	$Boxes.visible = true
func hide_boxes_content():
	$Boxes.visible = false

func buttons_activate(value:bool):
	$TopMenus/Control3/Green.disabled = not value
	$TopMenus/Control2/Yellow.disabled = not value
	$TopMenus/Control/Blue.disabled = not value

func specific_button_activate(value:bool, number):
	$TopMenus.get_child(number).get_child(0).disabled = not value

func squize_box_befor_taking_unit(ID):
	var object = $TopMenus.get_child(ID).get_child(0)
	tween_squize.interpolate_property(object, "rect_scale:x",
	   1, 0.8, 1, 
	 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_squize.interpolate_property(object, "rect_position:x",
	   0, 25, 1, 
	 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_squize.interpolate_property(self, "squize_time_multiplyier",
	   1, 3, 1, 
	 Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_squize.start()

func stop_squize_box(ID):
	var object = $TopMenus.get_child(ID).get_child(0)
	tween_squize.stop(object)
	squize_time_multiplyier = 1
