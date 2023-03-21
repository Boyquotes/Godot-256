extends Control

func _ready():
	pass # Replace with function body.

func _on_ButtonYes_button_down():
	get_parent().warningstween.bb_animate_pressing_button(6)

func _on_ButtonYes_button_up():
	get_parent().warningstween.bb_animatation_stopped(6)
	visible = false
	get_parent().visible = false
	Signals.emit_signal("swich_on_delete_word_mode",true)
func _on_ButtonYes_toggled(button_pressed):
	pass # Replace with function body.

func _on_ButtonNo_button_down():
	get_parent().warningstween.bb_animate_pressing_button(5)

func _on_ButtonNo_button_up():
	get_parent().warningstween.bb_animatation_stopped(5)
	visible = false
	get_parent().visible = false
func _on_ButtonNo_toggled(button_pressed):
	pass # Replace with function body.
