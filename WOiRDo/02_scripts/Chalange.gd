extends Control

export(NodePath) var ChallangeTween
onready var challangetween

var but_pressed=false

func _ready():
	challangetween=get_node(ChallangeTween)
	visible=false
	bb_disable_buttons(true)
	$Arena.visible=false
	$Achievements.visible=false


func bb_show_arena(value):
	$Arena.visible=value

func bb_show_score(value):
	$Score.visible=value

func bb_show_achivements(value):
	$Achievements.visible=value

func bb_disable_buttons(value):
	get_node("Back").disabled=value
	get_node("ShowAchiveButton").disabled=value

func bb_disable_pick_mode_buttons(value):
	get_node("PickMode/Daily").disabled=value
	get_node("PickMode/Weekly").disabled=value
	get_node("PickMode/Monthly").disabled=value
	get_node("PickMode/Full").disabled=value

func bb_disable_pick_mode_dayly_button(value):
	get_node("PickMode/Daily").disabled=value

func bb_disable_pick_mode_weekly_button(value):
	get_node("PickMode/Weekly").disabled=value

func bb_disable_pick_mode_monthly_button(value):
	get_node("PickMode/Monthly").disabled=value

func bb_disable_pick_mode_full_button(value):
	get_node("PickMode/Full").disabled=value

func bb_disable_arena_buttons(value):
	get_node("Arena/Next").disabled=value

func bb_disable_score_buttons(value):
	get_node("Score/Back").disabled=value

func bb_disable_back_from_achiv_buttons(value):
	get_node("Achievements/Back_from_Achive").disabled=value



func _on_Back_button_down():
	but_pressed=true
	challangetween.bb_animate_pressing_button(1)
func _on_Back_button_up():
	if but_pressed:
		but_pressed=false
		challangetween.bb_animatation_stopped(1)
		bb_disable_buttons(true)
		get_node("../MainAnim").play("04_hide_chalange_show_start")
func _on_Back_toggled(button_pressed):
	pass # Replace with function body.


func _on_ShowAchiveButton_button_down():
	but_pressed=true
	challangetween.bb_animate_pressing_button(2)
func _on_ShowAchiveButton_button_up():
	if but_pressed:
		but_pressed=false
		challangetween.bb_animatation_stopped(2)
		get_node("../MainAnim").play("04_hide_chalange_show_achivements")
func _on_ShowAchiveButton_toggled(button_pressed):
	pass # Replace with function body.

func _on_Back_from_Achive_button_down():
	but_pressed=true
	challangetween.bb_animate_pressing_button(9)
func _on_Back_from_Achive_button_up():
	if but_pressed:
		but_pressed=false
		challangetween.bb_animatation_stopped(9)
		get_node("../MainAnim").play("08_hide_achivements_show_chalange")
func _on_Back_from_Achive_toggled(button_pressed):
	pass # Replace with function body.



