extends Control


func _ready():
	pass # Replace with function body.

func _on_ButtonYes_button_down():
	get_parent().warningstween.bb_animate_pressing_button(9)

func _on_ButtonYes_button_up():
	get_parent().warningstween.bb_animatation_stopped(9)
	visible = false
	get_parent().visible = false
	Signals.emit_signal("user_still_wants_to_save_it")
func _on_ButtonYes_toggled(button_pressed):
	pass # Replace with function body.


func _on_ButtonNo_button_down():
	get_parent().warningstween.bb_animate_pressing_button(8)

func _on_ButtonNo_button_up():
	get_parent().warningstween.bb_animatation_stopped(8)
	visible = false
	get_parent().visible = false
func _on_ButtonNo_toggled(button_pressed):
	pass # Replace with function body.
