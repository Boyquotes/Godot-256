extends NinePatchRect

onready var arena = get_node("../..")

func _on_CorrectTween_tween_completed(object, key):
	match arena.correct_board_mode:
		0:
			pass
		1:
			arena.set_correct_board_mode(0)
		2:
			arena.set_correct_board_mode(3)
			$Correct.disabled = false
		3:
			pass

func _on_CorrectTween_tween_started(object, key):
	match arena.correct_board_mode:
		0:
			arena.set_correct_board_mode(2)
		1:
			pass
		2:
			pass
		3:
			arena.set_correct_board_mode(1)
			$Correct.disabled = true
