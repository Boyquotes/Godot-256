extends Control

func _ready():
	pass # Replace with function body.


func _on_ButtonNo_button_down():
	get_parent().warningstween.bb_animate_pressing_button(7)

func _on_ButtonNo_button_up():
	get_parent().warningstween.bb_animatation_stopped(7)
	visible = false
	get_parent().visible = false
func _on_ButtonNo_toggled(button_pressed):
	pass # Replace with function body.
