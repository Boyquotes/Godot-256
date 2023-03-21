extends Button

export (NodePath) var ChangeSnakesMetre_path = ".."
export (NodePath) var ChangeSnakesKey_path = ".."


func _on_Settings_back_button_button_down():
	pass # Replace with function body.
func _on_Settings_back_button_button_up():
	if get_node(ChangeSnakesMetre_path).original_metre_bot != get_node(ChangeSnakesMetre_path).metre_bot or get_node(ChangeSnakesMetre_path).original_metre_top != get_node(ChangeSnakesMetre_path).metre_top:
		var new_value_1 = get_node(ChangeSnakesMetre_path).metre_bot
		var new_value_2 = get_node(ChangeSnakesMetre_path).metre_top
		get_node(ChangeSnakesMetre_path).original_metre_bot = new_value_1
		get_node(ChangeSnakesMetre_path).original_metre_top = new_value_2
		InGameSignals.emit_signal("update_metre",new_value_1,new_value_2)

	if get_node(ChangeSnakesKey_path).original_key != get_node(ChangeSnakesKey_path).actual_key:
		var new_value_1 = get_node(ChangeSnakesKey_path).actual_key
		get_node(ChangeSnakesKey_path).original_key = new_value_1
		InGameSignals.emit_signal("update_key",new_value_1)
	InGameSignals.emit_signal("show_main_menu_back")
