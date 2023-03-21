extends Control


func _ready():
	pass # Replace with function body.

func _on_ButtonYes_button_down():
	get_parent().warningstween.bb_animate_pressing_button(12)

func _on_ButtonYes_button_up():
	get_parent().warningstween.bb_animatation_stopped(12)
	visible = false
	get_parent().visible = false


