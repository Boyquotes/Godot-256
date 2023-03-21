extends Control


func _ready():
	pass # Replace with function body.

func _on_ButtonYes_button_down():
	get_parent().warningstween.bb_animate_pressing_button(11)

func _on_ButtonYes_button_up():
	get_parent().warningstween.bb_animatation_stopped(11)
	visible = false
	get_parent().visible = false
	Signals.emit_signal("swich_on_delete_day_mode",true)
func _on_ButtonYes_toggled(button_pressed):
	pass # Replace with function body.

func _on_ButtonNo_button_down():
	get_parent().warningstween.bb_animate_pressing_button(10)

func _on_ButtonNo_button_up():
	get_parent().warningstween.bb_animatation_stopped(10)
	visible = false
	get_parent().visible = false
func _on_ButtonNo_toggled(button_pressed):
	pass # Replace with function body.
