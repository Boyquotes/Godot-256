extends Control

export (NodePath) var metre_top_sign_path 
export (NodePath) var metre_bot_sign_path 


var original_metre_bot = 4 
var original_metre_top = 4 

var metre_bot = 4 setget bb_set_metre_bot
var metre_top = 4 setget bb_set_metre_top

func _ready():
	get_node(metre_top_sign_path).read_sign(str(metre_top))
	get_node(metre_bot_sign_path).read_sign(str(metre_bot))


func bb_set_metre_bot(value):
	var new_metre_bot = metre_bot * value
	if new_metre_bot == 32:
		metre_bot = 2
	elif new_metre_bot == 1:
		metre_bot = 16
	else:
		metre_bot = new_metre_bot
	get_node(metre_bot_sign_path).read_sign(str(metre_bot))

func bb_set_metre_top(value):
	var new_metre_top = metre_top + value
	if new_metre_top == 16:
		metre_top = 2
	elif new_metre_top == 1:
		metre_top = 15
	else:
		metre_top = new_metre_top
	get_node(metre_top_sign_path).read_sign(str(metre_top))





func _on_TopPrevious_button_down():
	pass # Replace with function body.
func _on_TopPrevious_button_up():
	bb_set_metre_top(-1)


func _on_TopNext_button_down():
	pass # Replace with function body.
func _on_TopNext_button_up():
	bb_set_metre_top(1)


func _on_BotPrevious_button_down():
	pass # Replace with function body.
func _on_BotPrevious_button_up():
	bb_set_metre_bot(0.5)


func _on_BotNext_button_down():
	pass # Replace with function body.
func _on_BotNext_button_up():
	bb_set_metre_bot(2)
