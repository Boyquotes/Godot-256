extends Control

export(NodePath) var startscreentween

var but_pressed=false
var woirdos_limit = 4500

func _ready():
	$Title/Sign.read_sign("WOiRDo")
	visible=true
	pass # Replace with function body.

func bb_disable_buttons(value):
	$PasteWord.disabled=value
	$Chalange.disabled=value
	$Memory.disabled=value



func _on_PasteWord_button_down():
	but_pressed=true
	get_node(startscreentween).bb_animate_pressing_button(1)
	pass # Replace with function body.
func _on_PasteWord_button_up():
	if but_pressed:
		but_pressed=false
		if not Content.nr_of_woirdos>=woirdos_limit:
			bb_disable_buttons(true)
			get_node("../MainAnim").play("01_hide_start_show_screen")
			get_node(startscreentween).bb_animatation_stopped(1)
		else:
			Signals.emit_signal("show_warning7")
func _on_PasteWord_toggled(button_pressed):
	pass # Replace with function body.


func _on_Memory_button_down():
	but_pressed=true
	get_node(startscreentween).bb_animate_pressing_button(3)
func _on_Memory_button_up():
	if but_pressed:
		but_pressed=false
		bb_disable_buttons(true)
		get_node("../MainAnim").play("01_hide_start_show_memory")
		get_node(startscreentween).bb_animatation_stopped(3)
func _on_Memory_toggled(button_pressed):
	pass # Replace with function body.


func _on_Chalange_button_down():
	but_pressed=true
	get_node(startscreentween).bb_animate_pressing_button(2)
func _on_Chalange_button_up():
	if but_pressed:
		but_pressed=false
		bb_disable_buttons(true)
		get_node("../MainAnim").play("01_hide_start_show_chalange")
		get_node(startscreentween).bb_animatation_stopped(2)
func _on_Chalange_toggled(button_pressed):
	pass # Replace with function body.


func _on_Exit_button_down():
	but_pressed=true
	get_node(startscreentween).bb_animate_pressing_button(4)
func _on_Exit_button_up():
	if but_pressed:
		but_pressed=false
		bb_disable_buttons(true)
		get_node(startscreentween).bb_animatation_stopped(4)
		get_tree().quit()
