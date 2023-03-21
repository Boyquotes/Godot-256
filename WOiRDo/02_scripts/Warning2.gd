extends Control


func _ready():
	pass # Replace with function body.



func _on_ButtonYes_button_down():
	get_parent().warningstween.bb_animate_pressing_button(4)
func _on_ButtonYes_button_up():
	get_parent().warningstween.bb_animatation_stopped(4)
	visible = false
	get_parent().visible = false
	get_node("../../MainAnim").play("02_hide_screen_show_memory")
func _on_ButtonYes_toggled(button_pressed):
	pass # Replace with function body.

func _on_ButtonNo_button_down():
	get_parent().warningstween.bb_animate_pressing_button(3)
func _on_ButtonNo_button_up():
	get_parent().warningstween.bb_animatation_stopped(3)
	visible = false
	get_parent().visible = false
func _on_ButtonNo_toggled(button_pressed):
	pass # Replace with function body.
